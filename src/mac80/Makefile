FF = gfortran
FFLAGS = -std=legacy
PREFIX ?= /opt/zcimtools
BINDIR = ${PREFIX}/bin
LIBEXECDIR = ${PREFIX}/libexec
PROGRAM = mac80

all:	m80 mac80

mac80:	mac80.for
	$(FF) $(FFLAGS) -o mac80 mac80.for

clean:
	rm --force m80 mac80

install: all
	[ -d ${BINDIR} ] || mkdir -p ${BINDIR}
	[ -d ${LIBEXECDIR} ] || mkdir -p ${LIBEXECDIR}
	cp m80 ${BINDIR}/${PROGRAM}
	cp mac80 ${LIBEXECDIR}/${PROGRAM}

check: all
	rm -f example.hex example.prn example.prn.trim
	./m80 examples/example.mac
	diff -u example.hex expected/example.hex
	sed -e 23d -e 3d example.prn > example.prn.trim
	diff -u example.prn.trim expected/example.prn.trim
	@echo "PASS: results are as expected"
	rm -f example.hex example.prn example.prn.trim

.PHONY: all clean install check

