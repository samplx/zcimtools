/* lbrate 1.0 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001 Russell Marks. See main.c for license details.
 *
 * readhuff.h
 */

#define MAGIC_SQ	0xff76

extern unsigned char *convert_huff(unsigned char *data_in,
                                   unsigned long in_len,
                                   unsigned long *out_len_ptr);
