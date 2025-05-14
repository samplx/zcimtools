#
# Makefile for unarj 2.43 under Linux
#

CC = gcc
CFLAGS = -O2 -Wall -ansi -pedantic -DUNIX
PREFIX=/opt/zcimtools
INSTALLDIR=${PREFIX}/bin

all: unarj

unarj: unarj.o decode.o environ.o
	$(CC) $(CFLAGS) -o unarj unarj.o decode.o environ.o

clean:
	rm -f core unarj *.o *.out *~

install:
	cp unarj $(INSTALLDIR)

unarj.o: unarj.c unarj.h Makefile
environ.o:  environ.c unarj.h Makefile
decode.o:   decode.c unarj.h Makefile
