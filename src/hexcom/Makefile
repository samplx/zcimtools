#
#

ZCIMTOOLS_TARGET_DIR = /opt/zcimtools
PREFIX = $(ZCIMTOOLS_TARGET_DIR)
BINDIR = $(PREFIX)/bin

INSTALL = install

DEBUG =
OPTIMIZE = -O2
COPTIONS = -Wall -Wextra -std=gnu99

CFLAGS = $(DEBUG) $(OPTIMIZE) $(COPTIONS)

all: hexcom hexpat

install: all
	$(INSTALL) -d $(BINDIR)
	$(INSTALL) -m 755 hexcom $(BINDIR)
	$(INSTALL) -m 755 hexpat $(BINDIR)

clean:
	$(RM) hexcom hexpat

.PHONY: all clean check install
