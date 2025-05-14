/* lbrate 1.0 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001 Russell Marks. See main.c for license details.
 *
 * readlzw.c - read RLE+LZW-compressed files.
 *
 * This is based on zgv's GIF reader, via nomarch's readlzw.c.
 */

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <ctype.h>
#include "readrle.h"

#include "readlzw.h"


#define READ_WORD(x) (x)=rawinput(),(x)|=(rawinput()<<8)

/* now this is for the string table.
 * the st_ptr array stores which pos to back reference to,
 *  each string is [...]+ end char, [...] is traced back through
 *  the 'pointer' (index really), then back through the next, etc.
 *  a 'null pointer' is = to UNUSED.
 * the st_chr array gives the end char for each.
 *  an unoccupied slot is = to UNUSED.
 */
#define UNUSED 32767
#define MAXSTR 4096
static int st_ptr[MAXSTR],st_chr[MAXSTR],st_last;
static int st_ptr1st[MAXSTR];

#define ALLOC_BLOCK_SIZE	32768

/* this is for the byte -> bits mangler:
 *  dc_bitbox holds the bits, dc_bitsleft is number of bits left in dc_bitbox,
 */
static int dc_bitbox,dc_bitsleft;

static unsigned char *data_in_point,*data_in_max;
static unsigned char *data_out,*data_out_point;
static int data_out_len,data_out_allocated;
static unsigned int checksum;
static int oldver;

/* for the *STUPID* FSCKING *IDIOTIC* hashing crap we have to deal with
 * when the table is full. Whoever thought this one up needs to be shot,
 * buried, dug up, shot again, and slapped with a wet fish. Twice.
 */
#define MORONIC_HASH_SIZE	5003

#define HASH_STRING(code,k)	(((((code)>>4)^(k))|(((code)&15)<<8))+1)

static int moronic_hash_lookup[MORONIC_HASH_SIZE];
static unsigned char st_codeseen[MAXSTR];
static int st_oldverhashlinks[MAXSTR];


/* prototypes */
void inittable(void);
int addstring(int oldcode,int chr);
int readcode(int *newcode,int numbits);
void outputstring(int code);
void outputchr(int chr);
int findfirstchr(int code);
void codereplace(int oldcode,int k);


static int rawinput(void)
{
if(data_in_point<data_in_max)
  return(*data_in_point++);
return(-1);
}

static void rawoutput(int byte)
{
if(data_out_len>=data_out_allocated)
  {
  data_out_allocated+=ALLOC_BLOCK_SIZE;
  if((data_out=realloc(data_out,data_out_allocated))==NULL)
    fprintf(stderr,"lbrate: out of memory!\n"),exit(1);
  data_out_point=data_out+data_out_len;
  }

*data_out_point++=byte;
data_out_len++;
checksum+=byte;
}


unsigned char *convert_lzw_dynamic(unsigned char *data_in,
                                   unsigned long in_len,
                                   unsigned long *out_len_ptr)
{
int magic,version,orig_checksum,checktype;
int csize,orgcsize;
int newcode,oldcode,k=0;
int first=1;
int noadd;
int c;

*out_len_ptr=0;

if((data_out=malloc(data_out_allocated=ALLOC_BLOCK_SIZE))==NULL)
  fprintf(stderr,"lbrate: out of memory!\n"),exit(1);

data_in_point=data_in; data_in_max=data_in+in_len;
data_out_point=data_out; data_out_len=0;
dc_bitbox=dc_bitsleft=0;
outputrle(-1,NULL);	/* init RLE */
checksum=0;

READ_WORD(magic);
if(magic!=MAGIC_CR)
  {
  free(data_out);
  return(NULL);
  }

/* skip filename */
while((c=rawinput())!=0)
  if(c==-1)
    {
    free(data_out);
    return(NULL);
    }

/* four info bytes */
rawinput();
version=rawinput();
checktype=rawinput();
rawinput();

/* check version is supported */
switch(version&0xf0)
  {
  case 0x10:
    oldver=1;
    break;
  case 0x20:
    oldver=0;
    break;
  default:
    free(data_out);
    return(NULL);
  }

csize=9;		/* initial code size */
if(oldver) csize=12;
orgcsize=csize;
inittable();

oldcode=newcode=0;

if(oldver)
  oldcode=0xffff;

while(1)
  {
  if(!readcode(&newcode,csize))
    break;

  noadd=0;
  if(first) k=newcode,first=0,noadd=1;

  if(oldver)
    {
    if(newcode==0)
      {
      /* ver 1.x EOF code */
      break;
      }
    }
  else
    {
    if(newcode==256)
      {
      /* EOF code */
      break;
      }
    
    if(newcode==257)
      {
      csize=orgcsize;
      inittable();
      if(!readcode(&newcode,csize) || newcode==256)
        break;
      noadd=1;
      }
    }

  if((!oldver && newcode<=st_last) ||
     (oldver && st_chr[newcode]!=UNUSED))
    {
    outputstring(newcode);
    k=findfirstchr(newcode);
    }
  else
    {
    /* this is a bit of an assumption, but these ones don't seem to happen in
     * non-broken files, so...
     */
#if 0
    /* actually, don't bother, just let the checksum tell the story. */
    if(newcode>st_last+1)
      fprintf(stderr,"warning: bad LZW code\n");
#endif
/*    k=findfirstchr(oldcode);*/  /* don't think I need this */
    outputstring(oldcode);
    outputchr(k);
    }

  st_codeseen[newcode]=1;
  if(st_last==MAXSTR-1)
    {
    if(!oldver)
      codereplace(oldcode,k);
    }
  else
    {
    if(!noadd)
      {
      if(!addstring(oldcode,k))
        {
        /* XXX I think this is meant to be non-fatal?
         * well, nothing for now, anyway...
         */
        }
      if(st_last<MAXSTR-2 && st_last==((1<<csize)-2))
        {
        /* ver 1.x files will never get here, so no need to check */
        csize++;
        }
      }
    }

  oldcode=newcode;
  }

READ_WORD(orig_checksum);

/* see how the checksum turned out */
checksum&=0xffff;
if(checktype==0 && checksum!=orig_checksum)
  {
  free(data_out);
  return(NULL);
  }

*out_len_ptr=data_out_len;
return(data_out);
}


void inittable(void)
{
int f;

for(f=0;f<MORONIC_HASH_SIZE;f++)
  moronic_hash_lookup[f]=-1;

for(f=0;f<MAXSTR;f++)
  {
  st_chr[f]=UNUSED;
  st_ptr[f]=UNUSED;
  st_ptr1st[f]=UNUSED;
  st_oldverhashlinks[f]=UNUSED;
  st_codeseen[f]=0;
  }

st_last=-1;
if(oldver)
  {
  st_ptr[0]=st_chr[0]=st_ptr1st[0]=0xffff;	/* reserved */
  st_last++;			/* since it's a counter, for 1.x */
  }

for(f=0;f<256+(oldver?0:4);f++)
  {
  if(oldver)
    addstring(0xffff,f);
  else
    {
    /* some slightly yucky hardcoded stuff is needed here so
     * that the hashing works in exactly the right way...
     */
    addstring((f<256)?0x6fff:0x7fff,(f<256)?f:0);
    st_codeseen[f]=1;
    }
  }
}


/* required for finding true table index in ver 1.x files */
int oldver_getidx(int oldcode,int chr)
{
int lasthash,hashval;
int a,b,f;

/* in ver 1.x crunched files, we hash the code into the array. This
 * means we don't have a real st_last, but for compatibility with
 * the rest of the code we pretend it still means that. (st_last
 * has already been incremented by the time we get called.) In our
 * case it's only useful as a measure of how full the table is.
 */
if(oldcode==0xffff && chr==0)
  hashval=0x800;   /* special case (leaving the zero code free for EOF) */
else
  {
  /* normally we do a slightly awkward mid-square thing */
  a=(((oldcode+chr)|0x800)&0x1fff);
  b=(a>>1);
  hashval=(((b*(b+(a&1)))>>4)&0xfff);
  }

/* first, check link chain from there */
while(st_chr[hashval]!=UNUSED && st_oldverhashlinks[hashval]!=UNUSED)
  hashval=st_oldverhashlinks[hashval];

/* make sure we return early if possible to avoid adding link */
if(st_chr[hashval]==UNUSED)
  return(hashval);

lasthash=hashval;

/* slightly odd approach if it's not in that - first try skipping
 * 101 entries, then try them one-by-one. If should be impossible
 * for this to loop indefinitely, if the table isn't full. (And we
 * shouldn't have been called if it was full...)
 */
hashval+=101;
hashval&=0xfff;

if(st_chr[hashval]!=UNUSED)
  {
  for(f=0;f<MAXSTR;f++,hashval++,hashval&=0xfff)
    if(st_chr[hashval]==UNUSED)
      break;
  if(hashval==MAXSTR)
    return(-1);		/* table full, can't happen */
  }

/* add link to here from the end of the chain */
st_oldverhashlinks[lasthash]=hashval;

return(hashval);
}


/* add a string specified by oldstring + chr to string table */
int addstring(int oldcode,int chr)
{
int f,hash;
int idx;

st_last++;

/* this should be a can't happen: */
if((st_last&MAXSTR))
  {
  st_last=MAXSTR-1;
  return(1);		/* not too clear it should die or not... */
  }

idx=st_last;

if(oldver)
  {
  /* old version finds index in a rather odd way. */
  if((idx=oldver_getidx(oldcode,chr))==-1)
    return(0);
  }
else
  {
  /* new version needs some hash crap. */
  if(chr==UNUSED) chr=0;   /* avoid breaking array bounds on broken files */
  f=hash=HASH_STRING(oldcode,chr);

  /* XXX should check this is guaranteed to always find a space.
   * I'd *presume* so, but...
   */
  while(moronic_hash_lookup[f]!=-1)
    {
    f+=hash-MORONIC_HASH_SIZE;
    if(f<0) f+=MORONIC_HASH_SIZE;
    }

  moronic_hash_lookup[f]=idx;
  }

st_chr[idx]=chr;

/* XXX should I re-enable this? think it might be for new version,
 * at least. (Certainly no good for old one.)
 */
#if 0
if(st_last==oldcode)
  return(0);			/* corrupt */
#endif
if(oldcode>=MAXSTR) return(1);
st_ptr[idx]=oldcode;

if(st_ptr[oldcode]==UNUSED)          /* if we're pointing to a root... */
  st_ptr1st[idx]=oldcode;        /* then that holds the first char */
else                                 /* otherwise... */
  st_ptr1st[idx]=st_ptr1st[oldcode]; /* use their pointer to first */

return(1);
}


/* read a code of bitlength numbits */
int readcode(int *newcode,int numbits)
{
int bitsfilled,got;

bitsfilled=got=0;
(*newcode)=0;

while(bitsfilled<numbits)
  {
  if(dc_bitsleft==0)        /* have we run out of bits? */
    {
    if((dc_bitbox=rawinput())==-1)
      return(0);
    dc_bitsleft=8;
    }
  if(dc_bitsleft<numbits-bitsfilled)
    got=dc_bitsleft;
  else
    got=numbits-bitsfilled;
  
  /* XXX this is pretty ugly */
  dc_bitbox&=0xff;
  dc_bitbox<<=got;
  bitsfilled+=got;
  (*newcode)|=((dc_bitbox>>8)<<(numbits-bitsfilled));
  dc_bitsleft-=got;
  }

if((*newcode)<0 || (*newcode)>MAXSTR-1) return(0);

if(oldver)
  return(1);

/* new ver has some weird `filler' codes which we should ignore */
if(*newcode==258 || *newcode==259)
  return(readcode(newcode,numbits));

return(1);
}


void outputstring(int code)
{
static int buf[MAXSTR];
int *ptr=buf;

while(st_ptr[code]!=UNUSED && ptr<buf+MAXSTR)
  {
  *ptr++=st_chr[code];
  code=st_ptr[code];
  }

outputchr(st_chr[code]);
while(ptr>buf)
  outputchr(*--ptr);
}


/* XXX this might as well be a macro */
void outputchr(int chr)
{
outputrle(chr,rawoutput);
}


int findfirstchr(int code)
{
if(st_ptr[code]!=UNUSED)       /* not first? then use brand new st_ptr1st! */
  code=st_ptr1st[code];                /* now with no artificial colouring */
if(code==UNUSED)
  return(0);			/* defence against broken files */
return(st_chr[code]);
}


/* and here, the evil comes to pass. We want to try replacing an existing
 * code, so rather than doing what *every other LZW implementation ever* [1]
 * does - start again, or stop filling it - this one forces using a
 * specific hash to look for previously-used strings, and, arrrgggghhh.
 * Words can't express the agonising awfulness.
 *
 * But we have to have it, so here it is.
 *
 * [1] This may be a slight exaggeration. :-) But this approach does make
 * things annoyingly fiddly, for rather questionable gains.
 */
void codereplace(int oldcode,int chr)
{
int f,code,hash;

if(chr==UNUSED) chr=0;   /* avoid breaking array bounds on broken files */
f=hash=HASH_STRING(oldcode,chr);

/* XXX should make sure this can't loop infinitely */
while(moronic_hash_lookup[f]!=-1)
  { 
  code=moronic_hash_lookup[f];
  if(!st_codeseen[code])
    {
    /* reuse code */
    st_codeseen[code]=0;
    st_ptr[code]=oldcode;
    st_chr[code]=chr;
    st_ptr1st[code]=(st_ptr[oldcode]==UNUSED)?oldcode:st_ptr1st[oldcode];
    break;
    }
  
  f+=hash-MORONIC_HASH_SIZE;
  if(f<0) f+=MORONIC_HASH_SIZE;
  }
}
