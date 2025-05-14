FF = gfortran
FFLAGS = -std=legacy
PREFIX ?= /opt/zcimtools
BINDIR = ${PREFIX}/bin
LIBEXECDIR = ${PREFIX}/libexec
EXAMPLESDIR = ${PREFIX}/examples
PROGRAM = plm80v4

all: plm80v4 plm81v4 plm82v4

plm81v4:	plm81-4.f
	$(FF) $(FFLAGS) -o plm81v4 plm81-4.f

plm82v4:	plm82-4.f
	$(FF) $(FFLAGS) -o plm82v4 plm82-4.f

clean:
	rm -f plm80v4 plm81v4 plm82v4

install: plm80v4 plm81v4 plm82v4
	[ -d ${BINDIR} ] || mkdir -p ${BINDIR}
	cp plm80v4 ${BINDIR}/${PROGRAM}
	[ -d ${LIBEXECDIR} ] || mkdir -p ${LIBEXECDIR}
	cp plm81v4 plm82v4 ${LIBEXECDIR}

check:	all
	rm -f plmsamp.hex plmsamp.prn
	./plm80v4 examples/plmsamp.plm
	diff -u plmsamp.hex expected/plmsamp.hex
	# we need to blank out the timestamp
	sed -e '1s/........................$$/XXXXXXXXXXXXXXXXXXXXXXXX/' plmsamp.prn > plmsamp.prn.trim
	diff -u plmsamp.prn.trim expected/plmsamp.prn.trim
	@echo "PASS: results are as expected"
	rm -f plmsamp.hex plmsamp.prn plmsamp.prn.trim


.PHONY: all clean install check
