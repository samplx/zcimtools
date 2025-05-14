
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
    const char *method_name = "unknown";
    char buffer[64];
    switch (method) {
        case 1:
        case 2:
            method_name = "Stored";
            break;
        case 3:
            method_name = "Packed";
            break;
        case 4:
            method_name = "Squeezed";
            break;
        case 5:
        case 6:
        case 7:
            method_name = "crunched";
            break;
        case 8:
            method_name = "Crunched";
            break;
        case 9:
            method_name = "Squashed";
            break;
        case 127:
            method_name = "Compress";
            break;
        default:
            break;
    }
    snprintf(buffer, 64, "\"method\":\"%s\",\"methodId\":%d,", method_name, method);
    return strdup(buffer);
}

const char *get_sizes_and_crc(int original_size, int compressed_size, int has_crc, int crc) {
    char buffer[64];
    if (has_crc) {
        snprintf(buffer, 64, "\"original_size\":%d,\"compressed_size\":%d,\"crc\":\"%04X\"", original_size, compressed_size, crc);
    } else {
        snprintf(buffer, 64, "\"original_size\":%d,\"compressed_size\":%d", original_size, compressed_size);
    }
    return strdup(buffer);
}

const char *get_name(const char *header_filename) {
    char buffer[64];
    snprintf(buffer, 64, "{\"filename\":\"%s\",", header_filename);
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
            strncat(buffer, flag, 128);
        }
    }
    flag[4] = 'T';
    for (int n=0; n < 3; n++) {
        if ((orig_name[8+n] & 0x80) != 0) {
            flag[5] = '0' + n;
            strncat(buffer, flag, 128);
        }
    }
    return strdup(buffer);
}

void list_arc_in_json() {
    FILE *in;
    struct archived_file_header_tag hdr;
    const char *comma = "";

    if ((in = fopen(archive_filename, "rb")) == NULL) {
        fprintf(stderr, "zcim-arclist: unable to open: %s (%s)\n", archive_filename, strerror(errno));
        exit(1);
    }

    if (!skip_sfx_header(in) || !read_file_header(in, &hdr)) {
        fprintf(stderr, "zcim-arclist: invalid header: %s\n", archive_filename);
        exit(1);
    }

    printf("{\"archive\":\"%s\",\"kind\":\"arc\",\"elements\":[\n", archive_filename);

    do {
        if (!skip_file_data(in, &hdr)) {
            fprintf(stderr, "zcim-arclist: error reading data: %s\n", archive_filename);
            exit(1);
        }

        const char *name = get_name(hdr.name);
        const char *datetime = get_json_datetime("timestamp", hdr.date, hdr.time);
        const char *method = get_method(hdr.method);
        const char *sizes_and_crc = get_sizes_and_crc(hdr.orig_size, hdr.compressed_size, hdr.has_crc, hdr.crc);
        const char *flags = get_flags(hdr.orig_name);
        printf("%s%s%s%s%s}\n", comma, name, method, datetime, sizes_and_crc);
        free((void *)name);
        free((void *)datetime);
        free((void *)method);
        free((void *)sizes_and_crc);
        free((void *)flags);
        comma = ",";

        if (!read_file_header(in, &hdr)) {
            fprintf(stderr, "zcim-arclist: error reading header: %s\n", archive_filename);
        }
    } while (hdr.method != 0);

    printf("]}\n");

    fclose(in);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s filename\n", argv[0]);
        exit(2);
    }
    archive_filename = argv[1];
    opt_preservecase = 1;
    list_arc_in_json();
    exit(0);
}
