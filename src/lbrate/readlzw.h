/* lbrate 1.0 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001 Russell Marks. See main.c for license details.
 *
 * readlzw.h
 */

#define MAGIC_CR	0xfe76

extern unsigned char *convert_lzw_dynamic(unsigned char *data_in,
                                          unsigned long in_len,
                                          unsigned long *orig_len_ptr);
