/* lbrate 1.2 - fully extract CP/M `.lbr' archives.
 * Copyright (C) 2001-2023 Russell Marks.
 *
 * main.c - most of the non-decompression stuff.
 *
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

#define LBRATE_VER	"1.2"

#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <time.h>
#include <sys/types.h>
#include <utime.h>
#include <getopt.h>

#include "readrle.h"
#include "readhuff.h"
#include "readlzw.h"
#include "readlzh.h"


char *archive_filename=NULL;
char **archive_matchstrs=NULL;		/* NULL, or points to argv+N */
int num_matchstrs=0;

int opt_use_cdate=0;
int opt_list=0;
int opt_no_decompress=0;
int opt_test=0;
int opt_verbose=0;


struct lbr_file_entry_tag
  {
  int status;
  unsigned char orig83name[11];		/* original 8.3 name, *NOT* asciiz */
  int pos,len,crc;			/* 2 bytes each in file,
                                           though our len is bytes not rcds */
  unsigned int c_date,m_date;		/* ditto */
  unsigned int c_time,m_time;
  
  char name[13];			/* `nice' converted name, asciiz */
  };


/* there is no overall header for the archive, but there's a header
 * for each file stored in it. In .lbr these make up a `directory', stored
 * before the file data. And to be fair, the first header is *kind of*
 * an overall header, albeit a slightly odd one.
 *
 * And note special-case kludge for non-LBRs described below.
 *
 * returns zero if we couldn't get a header.
 */
int read_file_header(FILE *in,struct lbr_file_entry_tag *hdrp)
{
static int first=1;
unsigned char buf[7*2];		/* for pos/len/crc and 4 date/time fields */
int f,c;

if((hdrp->status=fgetc(in))==EOF)
  return(0);

/* special-case kludge; if it's at start of the `LBR' but looks like
 * a squeeze/crunch/LZH magic number, flag with length of -1.
 */
if(first)
  {
  first=0;
  if((c=fgetc(in))==EOF)
    return(0);
  c=(hdrp->status|(c<<8));
  
  if(c==MAGIC_SQ || c==MAGIC_CR || c==MAGIC_LZH)
    {
    hdrp->status=0;
    hdrp->len=-1;
    hdrp->name[0]=0;
    switch(c)
      {
      case MAGIC_SQ:  hdrp->orig83name[9]='q'; break;
      case MAGIC_CR:  hdrp->orig83name[9]='z'; break;
      case MAGIC_LZH: hdrp->orig83name[9]='y'; break;
      }
    return(1);
    }
  
  ungetc(c,in);
  }

if(fread(hdrp->orig83name,1,
         sizeof(hdrp->orig83name),in)!=sizeof(hdrp->orig83name) ||
   fread(buf,1,sizeof(buf),in)!=sizeof(buf))
  return(0);

/* skip remaining 6 unused bytes */
for(f=0;f<6;f++)
  if(fgetc(in)==EOF) return(0);

/* extract the bits from buf */
hdrp->pos=(buf[0]|(buf[1]<<8));
hdrp->len=(buf[2]|(buf[3]<<8))*128;
hdrp->crc=(buf[4]|(buf[5]<<8));		/* yes, only 16-bit CRC */

/* get possible date/time fields */
hdrp->c_date=(buf[6]|(buf[7]<<8));
hdrp->m_date=(buf[8]|(buf[9]<<8));
hdrp->c_time=(buf[10]|(buf[11]<<8));
hdrp->m_time=(buf[12]|(buf[13]<<8));

/* "A zero value is assumed to be equal to the creation date" - ludef5.doc */
if(hdrp->m_date==0)
  {
  hdrp->m_date=hdrp->c_date;
  hdrp->m_time=hdrp->c_time;
  }

/* make nicer, Unix-ish version of the name. Doesn't replace `/' at
 * this point, though.
 */
if(memcmp(hdrp->orig83name,"           ",11)==0)	/* 11 spaces */
  {
  /* special case */
  hdrp->name[0]=0;
  }
else
  {
  unsigned char *src=hdrp->orig83name;
  char *dst=hdrp->name;
  
  for(f=0;f<8 && *src!=' ';f++)
    *dst++=tolower((*src++)&127);	/* lowercase and strip top bit */

  src=hdrp->orig83name+8;

  /* add dot only if there's an extension */
  if(memcmp(hdrp->orig83name+8,"   ",3)!=0)
    *dst++='.';

  for(f=0;f<3 && *src!=' ';f++)
    *dst++=tolower((*src++)&127);	/* and again */
  
  *dst=0;	/* end string */
  }

return(1);
}


/* read file data, assuming header has just been read from in
 * and hdrp's data matches it. Caller is responsible for freeing
 * the memory allocated. Note that this seeks to position required
 * before reading (and seeks back after).
 * Returns NULL for file I/O error only; OOM is fatal (doesn't return).
 */
unsigned char *read_file_data(FILE *in,struct lbr_file_entry_tag *hdrp)
{
unsigned char *data;
int siz=hdrp->len;
long oldpos=ftell(in);

if(fseek(in,128*hdrp->pos,SEEK_SET)==-1)
  return(NULL);

if((data=malloc(siz))==NULL)
  fprintf(stderr,"lbrate: out of memory!\n"),exit(1);

if(fread(data,1,siz,in)!=siz)
  {
  free(data);
  data=NULL;
  }

/* an error here is pretty much fatal */
if(fseek(in,oldpos,SEEK_SET)==-1)
  fprintf(stderr,"lbrate: couldn't seek back to file directory, aborting!\n"),
    exit(1);

return(data);
}


unsigned int calc_crc(unsigned char *data,unsigned long len)
{
static unsigned int crc_lookup[256]=
  {
  0x0000,0x1021,0x2042,0x3063,0x4084,0x50A5,0x60C6,0x70E7,
  0x8108,0x9129,0xA14A,0xB16B,0xC18C,0xD1AD,0xE1CE,0xF1EF,
  0x1231,0x0210,0x3273,0x2252,0x52B5,0x4294,0x72F7,0x62D6,
  0x9339,0x8318,0xB37B,0xA35A,0xD3BD,0xC39C,0xF3FF,0xE3DE,
  0x2462,0x3443,0x0420,0x1401,0x64E6,0x74C7,0x44A4,0x5485,
  0xA56A,0xB54B,0x8528,0x9509,0xE5EE,0xF5CF,0xC5AC,0xD58D,
  0x3653,0x2672,0x1611,0x0630,0x76D7,0x66F6,0x5695,0x46B4,
  0xB75B,0xA77A,0x9719,0x8738,0xF7DF,0xE7FE,0xD79D,0xC7BC,
  0x48C4,0x58E5,0x6886,0x78A7,0x0840,0x1861,0x2802,0x3823,
  0xC9CC,0xD9ED,0xE98E,0xF9AF,0x8948,0x9969,0xA90A,0xB92B,
  0x5AF5,0x4AD4,0x7AB7,0x6A96,0x1A71,0x0A50,0x3A33,0x2A12,
  0xDBFD,0xCBDC,0xFBBF,0xEB9E,0x9B79,0x8B58,0xBB3B,0xAB1A,
  0x6CA6,0x7C87,0x4CE4,0x5CC5,0x2C22,0x3C03,0x0C60,0x1C41,
  0xEDAE,0xFD8F,0xCDEC,0xDDCD,0xAD2A,0xBD0B,0x8D68,0x9D49,
  0x7E97,0x6EB6,0x5ED5,0x4EF4,0x3E13,0x2E32,0x1E51,0x0E70,
  0xFF9F,0xEFBE,0xDFDD,0xCFFC,0xBF1B,0xAF3A,0x9F59,0x8F78,
  0x9188,0x81A9,0xB1CA,0xA1EB,0xD10C,0xC12D,0xF14E,0xE16F,
  0x1080,0x00A1,0x30C2,0x20E3,0x5004,0x4025,0x7046,0x6067,
  0x83B9,0x9398,0xA3FB,0xB3DA,0xC33D,0xD31C,0xE37F,0xF35E,
  0x02B1,0x1290,0x22F3,0x32D2,0x4235,0x5214,0x6277,0x7256,
  0xB5EA,0xA5CB,0x95A8,0x8589,0xF56E,0xE54F,0xD52C,0xC50D,
  0x34E2,0x24C3,0x14A0,0x0481,0x7466,0x6447,0x5424,0x4405,
  0xA7DB,0xB7FA,0x8799,0x97B8,0xE75F,0xF77E,0xC71D,0xD73C,
  0x26D3,0x36F2,0x0691,0x16B0,0x6657,0x7676,0x4615,0x5634,
  0xD94C,0xC96D,0xF90E,0xE92F,0x99C8,0x89E9,0xB98A,0xA9AB,
  0x5844,0x4865,0x7806,0x6827,0x18C0,0x08E1,0x3882,0x28A3,
  0xCB7D,0xDB5C,0xEB3F,0xFB1E,0x8BF9,0x9BD8,0xABBB,0xBB9A,
  0x4A75,0x5A54,0x6A37,0x7A16,0x0AF1,0x1AD0,0x2AB3,0x3A92,
  0xFD2E,0xED0F,0xDD6C,0xCD4D,0xBDAA,0xAD8B,0x9DE8,0x8DC9,
  0x7C26,0x6C07,0x5C64,0x4C45,0x3CA2,0x2C83,0x1CE0,0x0CC1,
  0xEF1F,0xFF3E,0xCF5D,0xDF7C,0xAF9B,0xBFBA,0x8FD9,0x9FF8,
  0x6E17,0x7E36,0x4E55,0x5E74,0x2E93,0x3EB2,0x0ED1,0x1EF0,
  };
unsigned char *ptr=data;
unsigned int crc=0;
int f;

for(f=0;f<len;f++)
  crc=(crc<<8)^crc_lookup[((crc>>8)&255)^*ptr++];

return(crc&0xffff);
}


/* simple wildcard-matching code. It implements shell-like
 * `*' and `?', but not `[]' or `{}'.
 * XXX might be nice to replace this with something better :-)
 */
int is_match(char *filename,char *wildcard)
{
char *ptr=filename,*match=wildcard;
char *tmp,*tmp2;
int old;
int ok=1;

while(*ptr && *match && ok)
  {
  switch(*match)
    {
    case '*':
      /* need to check that everything up to the next * or ? matches
       * at some point from here onwards */
       
      /* skip the `*', and any * or ? following */
      while(*match=='*' || *match=='?')
        match++;
      
      /* find the next * or ?, or the end of the name */
      tmp=strchr(match,'*');
      if(tmp==NULL) tmp=strchr(match,'?');
      if(tmp==NULL) tmp=match+strlen(match);
      tmp--;
        
      /* if *match is NUL, the * was the last char, so it's already matched
       * if tmp+1-match>strlen(ptr) then it can't possibly match
       */
      if(*match==0)
        ptr+=strlen(ptr);	/* just `*', so skip to end */
      else
        {
        if(tmp+1-match>strlen(ptr))
          ok=0;
        else
          {
          /* go forward through the string, attempting to match the text
           * from match to tmp (inclusive) each time
           */
          old=tmp[1]; tmp[1]=0;
          if((tmp2=strstr(ptr,match))==NULL)
            ok=0;		/* didn't match */
          else
            ptr=tmp2;
            
          tmp[1]=old;
          }
        }
      break;
      
    case '?':
      match++; ptr++;		/* always matches */
      break;
      
    default:
      if(*match!=*ptr)
        ok=0;
      else
        {
        match++;
        ptr++;
        }
    }
  }

if(*ptr || *match) ok=0;	/* if any text left, it didn't match */

return(ok);
}


/* see if file matches any of the match strings specified
 * on the cmdline.
 */
int file_matches(char *filename)
{
int f;

if(!num_matchstrs) return(1);

for(f=0;f<num_matchstrs;f++)
  if(is_match(filename,archive_matchstrs[f]))
    return(1);

return(0);
}


char *add_parens(char *str)
{
static char buf[1024];

buf[0]='(';
buf[1]=0;
strncat(buf,str,sizeof(buf)-3);
strcat(buf,")");

return(buf);
}


/* check compression method and return original filename.
 * filedata should contain at least the first 128 bytes of the file.
 */
int check_method_and_name(unsigned char *filedata,
                          struct lbr_file_entry_tag *hdrp,
                          char **output_filename)
{
static char name[128];
int magic;
int method=0;
unsigned char *src;
char *dst,*ptr;

magic=(filedata[0]|(filedata[1]<<8));

if(magic==MAGIC_SQ && tolower(hdrp->orig83name[9]&127)=='q')
  method=1;

if(magic==MAGIC_CR && tolower(hdrp->orig83name[9]&127)=='z')
  method=2;

if(magic==MAGIC_LZH && tolower(hdrp->orig83name[9]&127)=='y')
  method=3;

if(method<1 || method>3)
  {
  *output_filename=NULL;
  return(method);
  }

/* asciiz original filename */
src=filedata+(method==1?4:2);
dst=name;
while(src<filedata+128 && *src)
  *dst++=tolower((*src++)&127);
*dst=0;
*output_filename=name;

/* some crunched files stick comments/date stamps after `['
 * or the three full bytes of extension, so lose that.
 * also lose any stuff after a space.
 */
if((ptr=strchr(name,'['))!=NULL)
  *ptr=0;

if((ptr=strchr(name,' '))!=NULL)
  *ptr=0;

if((ptr=strchr(name,'.'))!=NULL && ptr<name+sizeof(name)-4)
  ptr[4]=0;

/* finally, drop any trailing dot. */
if(*name && name[strlen(name)-1]=='.')
  name[strlen(name)-1]=0;

return(method);
}


/* this is pretty ugly, but probably less ugly than having most
 * of lbrate in a separate utility too, just to handle the odd
 * outside-an-LBR squeezed/crunched file.
 *
 * As for this routine, it fixes up hdr as needed, and returns
 * the contents of the file.
 */
unsigned char *kludge_for_compressed_file(FILE *in,
                                          struct lbr_file_entry_tag *hdrp,
                                          char *archive_filename)
{
long len=-1;
char *ptr;

/* copy as much as we can of non-path part of filename */
if((ptr=strrchr(archive_filename,'/'))==NULL)
  ptr=archive_filename;
else
  ptr++;
strncpy(hdrp->name,ptr,sizeof(hdrp->name)-1);
hdrp->name[sizeof(hdrp->name)-1]=0;

if(fseek(in,0,SEEK_END)==-1 || (len=ftell(in))==-1)
  fprintf(stderr,"lbrate: couldn't determine file size\n"),
    exit(1);

hdrp->status=0;
hdrp->pos=0;
hdrp->len=len;
hdrp->crc=0;
hdrp->c_date=hdrp->c_time=0;
hdrp->m_date=hdrp->m_time=0;

return(read_file_data(in,hdrp));
}


/* convert to date/time format to time_t */
time_t mkdatetimet(unsigned int hdate,unsigned int htime)
{
static time_t cpm3_date_base=252374400;		/* 0:00, 31 Dec 1977 */
static time_t daylen=86400;			/* a 24-hour day in seconds */
struct tm *tms,tmnew;
time_t t;

if(!hdate) return(0);

/* the GNU libc manual says "POSIX requires that this count [time_t] ignore
 * leap seconds", but it seems a bit risky to rely on that. So we convert
 * the date separately (adding on half a day to make sure), then convert
 * back after filling in the proper time.
 */
t=cpm3_date_base+(time_t)hdate*daylen+daylen/2;

/* using gmtime here, since the base is UTC */
if((tms=gmtime(&t))==NULL)
  return(0);

tmnew=*tms;
tmnew.tm_hour=(htime>>11);
tmnew.tm_min=((htime>>5)&63);
tmnew.tm_sec=(htime&31)*2;
tmnew.tm_isdst=-1;	/* i.e. unknown */

if((t=mktime(&tmnew))==(time_t)-1)
  return(0);

return(t);
}


/* convert date/time format to string */
char *mkdatetimestr(unsigned int hdate,unsigned int htime)
{
static char buf[128];
struct tm *tms;
time_t t=mkdatetimet(hdate,htime);

if(t==0 || (tms=localtime(&t))==NULL)
  {
  *buf=0;
  return(buf);
  }

sprintf(buf,"%4d-%02d-%02d %02d:%02d",
        tms->tm_year+1900,tms->tm_mon+1,tms->tm_mday,
        tms->tm_hour,tms->tm_min);

return(buf);
}



int arc_list(int verbose)
{
#define NUM_METHODSTR 4
char *methodstr[NUM_METHODSTR]=
  {
  "Stored",
  "Squeezed",
  "Crunched",
  "LZH"
  };
FILE *in;
struct lbr_file_entry_tag hdr;
unsigned char *data;
char *ptr,*dptr,*orig_name;
int real_len;
int method;
int numdir;
int f;
unsigned int sdate,stime;

if((in=fopen(archive_filename,"rb"))==NULL)
  fprintf(stderr,"lbrate: %s\n",strerror(errno)),exit(1);

/* the first entry is guaranteed active, with 11-blanks filename */
if(!read_file_header(in,&hdr) || hdr.status!=0 || *hdr.name)
  fprintf(stderr,
          "lbrate: bad first header - not a .lbr or compressed file?\n"),
    exit(1);

numdir=hdr.len/32;
if(hdr.len==-1)
  numdir=2;	/* see below */

for(f=1;f<numdir;f++)
  {
  if(numdir==2)
    {
    /* numdir of 2 is impossible in LBR; this is a single compressed file. */
    data=kludge_for_compressed_file(in,&hdr,archive_filename);
    real_len=hdr.len;
    }
  else
    {
    if(!read_file_header(in,&hdr))
      fprintf(stderr,"lbrate: error reading record header\n"),exit(1);
    
    if(hdr.status!=0)
      continue;
    
    /* we only really need first record to determine format, so
     * lie about it... :-) (after all, we're not testing here, just listing)
     */
    real_len=hdr.len;
    if(real_len>128)
      hdr.len=128;
    
    data=read_file_data(in,&hdr);
    }
  
  if(!data)
    {
    fflush(stdout);
    fprintf(stderr,"lbrate: error reading data (hit EOF)\n"),exit(1);
    }
  
  method=check_method_and_name(data,&hdr,&orig_name);
  free(data);
  ptr=(orig_name && !opt_no_decompress?orig_name:hdr.name);

  if(file_matches(ptr))
    {
    if(opt_use_cdate)
      sdate=hdr.c_date,stime=hdr.c_time;
    else
      sdate=hdr.m_date,stime=hdr.m_time;

    dptr=mkdatetimestr(sdate,stime);
    
    if(verbose)
      printf("%-12s  %-14s\t%-8s  %9d  %-16s  %04X\n",
             ptr,
             ptr==orig_name?add_parens(hdr.name):"",
             method<NUM_METHODSTR?methodstr[method]:"unknown",
             real_len,*dptr?dptr:"  <no date>",hdr.crc);
    else
      printf("%-12s\t%9d   %s\n",ptr,real_len,dptr);
    }
  }

fclose(in);

return(0);
}


int arc_extract_or_test(int test_only)
{
FILE *in;
struct lbr_file_entry_tag hdr;
unsigned char *data,*orig_data;
char *name,*orig_name;
unsigned long output_len;
int supported;
int exitval=0;
int method;
int numdir;
int crc_warning;
int f;

if((in=fopen(archive_filename,"rb"))==NULL)
  fprintf(stderr,"lbrate: %s\n",strerror(errno)),exit(1);

/* the first entry is guaranteed active, with 11-blanks filename */
if(!read_file_header(in,&hdr) || hdr.status!=0 || *hdr.name)
  fprintf(stderr,
          "lbrate: bad first header - not a .lbr or compressed file?\n"),
    exit(1);

numdir=hdr.len/32;
if(hdr.len==-1)
  numdir=2;	/* see below */

for(f=1;f<numdir;f++)
  {
  if(numdir==2)
    {
    /* numdir of 2 is impossible in LBR; this is a single compressed file. */
    data=kludge_for_compressed_file(in,&hdr,archive_filename);
    }
  else
    {
    if(!read_file_header(in,&hdr))
      fprintf(stderr,"lbrate: error reading record header\n"),exit(1);
    
    if(hdr.status!=0)
      continue;
    
    data=read_file_data(in,&hdr);
    }

  if(!data)
    {
    fflush(stdout);
    fprintf(stderr,"lbrate: error reading data (hit EOF)\n"),exit(1);
    }
  
  name=hdr.name;
  method=0;
  if(!opt_no_decompress)
    {
    method=check_method_and_name(data,&hdr,&orig_name);
    if(orig_name) name=orig_name;
    }
  
  if(file_matches(name))
    {
    /* decompress file data */
    printf("%-12s\t",name);
    fflush(stdout);
    
    /* check CRC now (since we can), but don't warn about it unless
     * we get an otherwise error-free extract. And we have to ignore
     * all-zero CRCs, as these mean no CRC is present.
     */
    crc_warning=0;
    if(hdr.crc && calc_crc(data,hdr.len)!=hdr.crc)
      crc_warning=1;
    
    orig_data=NULL;
    supported=0;
    output_len=0;

    /* pretend it's uncompressed already, if `-n'. */
    if(opt_no_decompress) method=0;
    
    switch(method)
      {
      case 0:		/* no compression */
        supported=1;
        orig_data=data;
        output_len=hdr.len;
        break;

      case 1:		/* "squeezed" */
        supported=1;
        orig_data=convert_huff(data,hdr.len,&output_len);
        break;

      case 2:		/* "crunched" */
        supported=1;
        orig_data=convert_lzw_dynamic(data,hdr.len,&output_len);
        break;

      case 3:		/* LZH */
        supported=1;
        orig_data=convert_lzh(data,hdr.len,&output_len);
        break;
      }

    if(orig_data==NULL)
      {
      if(supported)
        {
        /* this can only happen when decompression failed.
         * Since all OOM errors are fatal, this means something was
         * wrong with the compressed file.
         */
        if(test_only)
          {
          /* if testing, LBR CRC warning trumps it */
          printf("test failed, %s\n",
                 crc_warning?"bad CRC":"error decompressing");
          }
        else
          {
          /* the "file skipped" bit is to try and communicate the
           * idea that we're not even attempting to write any
           * file data (since we weren't returned any!).
           */
          printf("error decompressing, file skipped%s\n",
                 crc_warning?"":" (seems valid at LBR level?)");
          }
        }
      else
        printf("unsupported internal method %d - can't happen!\n",
               method);
      exitval=1;
      }
    else
      {
      FILE *out=NULL;
      char *ptr;

      /* CP/M stuff likes those slashes... */
      while((ptr=strchr(name,'/'))!=NULL)
        *ptr='_';	/* bit naughty for orig_name, but what the heck */

      /* write the file, if not just testing */
      if(!test_only && (out=fopen(name,"wb"))==NULL)
        {
        printf("error, %s\n",strerror(errno));
        exitval=1;
        }
      else
        {
        if(!test_only && fwrite(orig_data,1,output_len,out)!=output_len)
          {
          printf("error, %s\n",strerror(errno));
          exitval=1;
          }
        else
          {
          /* XXX the "warning" idea is a bit broken for compressed files,
           * since they have their own currently-error-causing checksum
           * which breaks rather than merely warning.
           */
          if(crc_warning)
            {
            printf("%s, bad CRC\n",test_only?"test failed":"warning");
            exitval=1;
            }
          else
            printf("ok\n");
          }
      
        if(!test_only)
          {
          struct utimbuf ubuf;
          time_t t;
          unsigned int sdate,stime;
        
          fclose(out);

          if(opt_use_cdate)
            sdate=hdr.c_date,stime=hdr.c_time;
          else
            sdate=hdr.m_date,stime=hdr.m_time;
          
          /* if we have a usable date/time, alter atime/mtime */
          t=mkdatetimet(sdate,stime);
          if(t!=0)
            {
            ubuf.actime=ubuf.modtime=t;
            utime(name,&ubuf);
            }
          }
        }

      if(orig_data!=data)	/* don't free uncompressed stuff twice :-) */
        free(orig_data);
      }
  
    free(data);
    }
  }

fclose(in);

return(exitval);
}


void usage_help(void)
{
printf("lbrate " LBRATE_VER " - copyright (c) 2001-2023 Russell Marks.\n");
printf("\n"
"usage: lbrate [-chlntv] [archive.lbr] [match1 [match2 ...]]\n"
"\n"
"	-c	use/show creation date/time rather than last-modified.\n"
"		(But note that many LBRs lack dates/times entirely.)\n"
"	-h	this usage help.\n"
"	-l	list contents of archive.\n"
"	-n	no decompression - extract files from LBR as-is.\n"
"		(Also causes listing of compressed filenames only.)\n"
"	-t	test archive (i.e. check file CRCs).\n"
"	-v	give verbose listing (when used with `-l').\n"
"\n"
"  archive.lbr	the LBR file to list/extract/test.\n"
"		(The default action is to extract the files.)\n"
"		You can also work with CP/M-ish compressed files as if\n"
"		they were single-entry LBRs.\n"
"\n"
"  match1 etc.	zero or more wildcards, for files to list/extract/test;\n"
"		the file is processed if it matches any one of these.\n"
"		(If *no* wildcards are specified, all files match.)\n"
"		Wildcard operators supported are shell-like `*' and `?'.\n");
}


void parse_options(int argc,char *argv[])
{
int done=0;

archive_filename=NULL;

opterr=0;

do
  switch(getopt(argc,argv,"chlntv"))
    {
    case 'c':	/* use creation date */
      opt_use_cdate=1;
      break;
    case 'h':
      usage_help();
      exit(0);
    case 'l':	/* list */
      opt_list=1;
      break;
    case 'n':	/* no decompression */
      opt_no_decompress=1;
      break;
    case 't':	/* test */
      opt_test=1;
      break;
    case 'v':	/* verbose (list) */
      opt_verbose=1;
      break;
    case '?':
      fprintf(stderr,"lbrate: option `%c' not recognised.\n",optopt);
      exit(1);
    case -1:
      done=1;
    }
while(!done);

/* get any match strings */
if(argc-optind>1)
  {
  archive_matchstrs=argv+optind+1;
  num_matchstrs=argc-optind-1;
  }

if(argc==optind)	/* if no filename */
  usage_help(),exit(1);

archive_filename=argv[optind];
}


int main(int argc,char *argv[])
{
parse_options(argc,argv);

if(opt_list && opt_test)
  opt_list=0;	/* test wins */

if(opt_list)
  exit(arc_list(opt_verbose));

exit(arc_extract_or_test(opt_test));
}
