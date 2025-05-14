FF = gfortran
FFLAGS = -std=legacy
PREFIX ?= /opt/zcimtools
BINDIR = ${PREFIX}/bin
LIBEXECDIR = ${PREFIX}/libexec
EXAMPLESDIR = ${PREFIX}/examples
PROGRAM = plm80v2

all: plm80 plm81 plm82

plm81:	plm81.for
	$(FF) $(FFLAGS) -o plm81 plm81.for

plm82:	plm82.for
	$(FF) $(FFLAGS) -o plm82 plm82.for

clean:
	rm -f plm80 plm81 plm82

check:	all
	rm -f plmsamp.hex plmsamp.prn
	./plm80 examples/plmsamp.plm
	diff -u plmsamp.hex examples/plmsamp.hex
	diff -u plmsamp.prn examples/plmsamp.prn
	@echo "PASS: results are as expected"
	rm -f plmsamp.hex plmsamp.prn

install: plm80 plm81 plm82
	[ -d ${BINDIR} ] || mkdir -p ${BINDIR}
	cp plm80 ${BINDIR}/${PROGRAM}
	(cd ${BINDIR}; ln -s ${PROGRAM} plm80)
	[ -d ${LIBEXECDIR} ] || mkdir -p ${LIBEXECDIR}
	cp plm81 plm82 ${LIBEXECDIR}
	[ -d ${EXAMPLESDIR} ] || mkdir -p ${EXAMPLESDIR}
	cp -r examples ${EXAMPLESDIR}

.PHONY: all clean install check
