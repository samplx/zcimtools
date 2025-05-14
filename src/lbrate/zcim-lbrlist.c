
#define main    __never_called__
#include "main.c"
#undef main

const char *get_json_datetime(const char *fieldname, unsigned hdate, unsigned htime) {
    if (hdate == 0) {
        return strdup("");
    }
    char *datetime = mkdatetimestr(hdate, htime);
    if ((datetime != NULL) && *datetime) {
        datetime[10] = 'T';
        char buffer[512];
        snprintf(buffer, 512, "\"%s\":\"%s\",", fieldname, datetime);
        return strdup(buffer);
    }
    return strdup("");
}

const char *get_method(int method) {
    switch (method) {
        case 0:
            return "\"method\":\"stored\",";
        case 1:
            return "\"method\":\"squeezed\",";
        case 2:
            return "\"method\":\"crunched\",";
        case 3:
            return "\"method\":\"lzh\",";
        default:
            break;
    }
    return "\"method\":\"unknown\",";
}

const char *get_size_and_crc(int method, int crc, int size) {
    char buffer[64];
    if ((method <= 0) || (method > 3) || ((method == 1) && (crc == 0))) {
        snprintf(buffer, 64, "\"size\":%d", size);
    } else {
        snprintf(buffer, 64, "\"size\":%d,\"crc\":\"%04X\"", size, crc);
    }
    return strdup(buffer);
}

const char *get_start(const char *original_filename, const char *header_filename) {
    char buffer[128];
    if ((original_filename == NULL) || (strcmp(original_filename, header_filename) == 0)) {
        snprintf(buffer, 128, "{\"filename\":\"%s\",", header_filename);
    } else {
        snprintf(buffer, 128, "{\"filename\":\"%s\",\"original\":\"%s\",", header_filename, original_filename);
    }
    return strdup(buffer);
}

const char *get_flags(const char *orig_name) {
    char flag[] = ",\"isXX\":true";
    char buffer[129];

    *buffer = 0;
    flag[4] = 'F';
    for (int n=0; n < 4; n++) {
        if ((orig_name[n] & 0x80) != 0) {
            flag[5] = '0' + n;
            strncat(buffer, flag, 127);
        }
    }
    flag[4] = 'T';
    for (int n=0; n < 3; n++) {
        if ((orig_name[8+n] & 0x80) != 0) {
            flag[5] = '0' + n;
            strncat(buffer, flag, 127);
        }
    }
    return strdup(buffer);
}


void list_lbr_in_json() {
    FILE *in;
    struct lbr_file_entry_tag hdr;
    unsigned char *data;
    char *original_filename;

    if ((in = fopen(archive_filename, "rb")) == NULL) {
        fprintf(stderr, "zcim-lbrlist: unable to open: %s (%s)\n", archive_filename, strerror(errno));
        exit(1);
    }

    if (!read_file_header(in, &hdr) || (hdr.status != 0) || *hdr.name) {
        fprintf(stderr, "zcim-lbrlist: invalid header: %s\n", archive_filename);
        exit(1);
    }

    if (hdr.len != -1) {
        printf("{\"archive\":\"%s\",\"kind\":\"lbr\",\"elements\":[\n", archive_filename);
        unsigned numdir = hdr.len / 32;
        for (unsigned f=1; f < numdir; f++) {
            if (!read_file_header(in, &hdr)) {
                fprintf(stderr, "zcim-lbrlist: error reading header: %s\n", archive_filename);
                exit(1);
            }
            if (hdr.status != 0) {
                continue;
            }
            int real_len = hdr.len;
            if (real_len > 128) {
                hdr.len = 128;
            }
            data = read_file_data(in, &hdr);
            if (data == NULL) {
                fprintf(stderr, "zcim-lbrlist: error reading data: %s\n", archive_filename);
                exit(1);
            }
            int method = check_method_and_name(data, &hdr, &original_filename);
            const char *modified_datetime = get_json_datetime("modified", hdr.m_date, hdr.m_time);
            const char *created_datetime = get_json_datetime("created", hdr.c_date, hdr.c_time);
            const char *start = get_start(original_filename, hdr.name);
            const char *comma = (f == 1) ? "" : ",";
            const char *size_and_crc = get_size_and_crc(method, hdr.crc, real_len);
            const char *flags = get_flags((const char *)hdr.orig83name);
            printf("%s%s%s%s%s%s%s}\n", comma, start, get_method(method), created_datetime, modified_datetime, size_and_crc, flags);
            free((void *)data);
            free((void *)modified_datetime);
            free((void *)created_datetime);
            free((void *)start);
            free((void *)size_and_crc);
            free((void *)flags);
        }
        printf("]}\n");
    }
    fclose(in);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s filename\n", argv[0]);
        exit(2);
    }
    archive_filename = argv[1];
    list_lbr_in_json();
    exit(0);
}
