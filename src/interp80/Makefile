FF = gfortran
FFLAGS = -std=legacy
PREFIX ?= /opt/zcimtools
BINDIR = ${PREFIX}/bin
LIBEXECDIR = ${PREFIX}/libexec
PROGRAM = interp80

all:	interp80 i80

interp80:	interp80.for
	$(FF) $(FFLAGS) -o interp80 interp80.for

clean:
	rm -f interp80 i80

install: all
	[ -d ${BINDIR} ] || mkdir -p ${BINDIR}
	[ -d ${LIBEXECDIR} ] || mkdir -p ${LIBEXECDIR}
	cp i80 ${BINDIR}/${PROGRAM}
	cp interp80 ${LIBEXECDIR}/${PROGRAM}

check: all
	rm -f example.out
	./i80 examples/example.in examples/example.hex
	diff -u example.out examples/example.out
	@echo "PASS: results are as expected"
	rm -f example.out

.PHONY: all clean install check
