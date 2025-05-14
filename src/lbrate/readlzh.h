/* lbrate 1.0 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001 Russell Marks. See main.c for license details.
 *
 * readlzh.h
 */

#define MAGIC_LZH	0xfd76

extern unsigned char *convert_lzh(unsigned char *data_in,
                                  unsigned long in_len,
                                  unsigned long *out_len_ptr);
