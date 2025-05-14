#!/bin/sh

#
# UNIX Compiler Driver for Intel 8080 Macro Cross Assembler
#
# October 2007, Udo Munk
# September 2008, try various different filename extensions, Udo Munk
# August 31, 2024, modified to run under docker(debian). Jim Burlingame
#

PREFIX="${ZCIMTOOLS_TARGET_DIR:-"/opt/zcimtools"}"
LIBEXECDIR="${ZCIMTOOLS_LIBEXECDIR:-"${PREFIX}/libexec"}"

PROGRAM_NAME="${0##*/}"

#check for input source file
if [ "$#" -ne 1 ]
then
	echo "Usage: $PROGRAM_NAME source-file" 2>&1
	exit 2
fi

if [ ! -f "$1" ]
then
    if [ "$1" = "--help" ]
    then
        echo "Usage: $PROGRAM_NAME source-file"
        exit 0
    else
        echo "ERROR: source file $1 does not exist." 2>&1
        exit 1
    fi
fi

# figure where source is
SOURCE_FILE="$(readlink --canonicalize-existing "$1")"
SOURCE_BASE="${SOURCE_FILE##*/}"
# get rid of filename extension
FN="${SOURCE_BASE%.*}"

CURRENT_DIRECTORY="$(readlink --canonicalize-existing .)"
TMP_DIRECTORY="$(mktemp -d -t mac80.XXXXXXXXX)" || exit 86
cd "$TMP_DIRECTORY" || exit 86

# setup I/O for the assembler
# source read from channel 7
cp "$SOURCE_FILE" fort.7
# channel 1 assembler switches, redirection of input must be last line!
cat >fort.1 <<!!EOF
\$T=1
\$O=3
\$I=2
!!EOF

# run assembler
if [ -x "$CURRENT_DIRECTORY/mac80" ]
then
    # handle development (local directory) copy
    "$CURRENT_DIRECTORY/mac80"
else
    "${LIBEXECDIR}/mac80"
fi

# get listing from channel 8
if [ -f fort.8 ]
then
	rm -f "$CURRENT_DIRECTORY/${FN}.prn"
	mv fort.8 "$CURRENT_DIRECTORY/${FN}.prn"
fi

# get hex file from channel 9
if [ -f fort.9 ]
then
	rm -f "$CURRENT_DIRECTORY/${FN}.hex"
	mv fort.9 "$CURRENT_DIRECTORY/${FN}.hex"
fi

# show assembler tty output
if [ -f fort.2 ]
then
	cat fort.2
fi

# clean up
cd "${CURRENT_DIRECTORY}" || exit 86
rm --recursive --force "${TMP_DIRECTORY}"

exit 0
