# Makefile - makefile for lbrate

CC=gcc
CFLAGS=-O3 -Wall

# Set BINDIR to directory for binary,
# MANDIR to directory for man page.
# Usually it will be simpler to just set PREFIX.
#
PREFIX=/opt/zcimtools
BINDIR=$(PREFIX)/bin
MANDIR=$(PREFIX)/man/man1

# You shouldn't need to edit below this line.
#--------------------------------------------------------

OBJ=main.o readrle.o readhuff.o readlzw.o readlzh.o

all: lbrate zcim-lbrlist

lbrate: $(OBJ)
	$(CC) $(CFLAGS) -o lbrate $(OBJ)

installdirs:
	/bin/sh ./mkinstalldirs $(BINDIR) $(MANDIR)

install: installdirs lbrate zcim-lbrlist
	install -m 755 lbrate $(BINDIR)
	install -m 755 zcim-lbrlist $(BINDIR)
	install -m 644 lbrate.1 $(MANDIR)

uninstall:
	$(RM) $(BINDIR)/lbrate $(BINDIR)/zcim-lbrlist $(MANDIR)/lbrate.1

clean:
	$(RM) *.o *~ lbrate zcim-lbrlist


# stuff to make distribution tgz

VERS=1.2

tgz: ../lbrate-$(VERS).tar.gz

../lbrate-$(VERS).tar.gz: clean
	@cd ..;ln -s lbrate lbrate-$(VERS)
	cd ..;tar zchvf lbrate-$(VERS).tar.gz lbrate-$(VERS)
	@cd ..;$(RM) lbrate-$(VERS)

# zcim additions

zcim-lbrlist:	zcim-lbrlist.c main.c readrle.o readhuff.o readlzw.o readlzh.o
	$(CC) $(CFLAGS) -o zcim-lbrlist zcim-lbrlist.c readrle.o readhuff.o readlzw.o readlzh.o

.PHONY: all installdirs install uninstall clean tgz
