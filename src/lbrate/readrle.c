/* lbrate 1.0 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001 Russell Marks. See main.c for license details.
 *
 * readrle.c - undo RLE compression. Based on nomarch's readrle.c.
 *
 * In lbrate, this is present only for the generic outputrle().
 */

#include "readrle.h"


/* call with -1 before starting, to make sure state is initialised */
void outputrle(int chr,void (*outputfunc)(int))
{
static int lastchr=0,repeating=0;
int f;

if(chr==-1)
  {
  lastchr=repeating=0;
  return;
  }

if(repeating)
  {
  if(chr==0)
    (*outputfunc)(0x90);
  else
    for(f=1;f<chr;f++)
      (*outputfunc)(lastchr);
  repeating=0;
  }
else
  {
  if(chr==0x90)
    repeating=1;
  else
    {
    (*outputfunc)(chr);
    lastchr=chr;
    }
  }
}
