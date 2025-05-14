#!/bin/bash

#
# UNIX Compiler Driver for Intel PL/M-80 v 4.0 Cross Compiler
#
# December 2006, Udo Munk
# January 2007, improved error handling, Udo Munk
# September 2007, source file now can be located anywhere.
#		  pass 2 might not generate the hex output file,
#		  if too may errors in pass 1, trapped. Udo Munk
# October 2007, clean temp if error in pass 2, Udo Munk
# July 2014, modified for v 4.0 compiler so that both can co-exist
# August 31, 2024, modified to run under docker(debian). Jim Burlingame
#

PREFIX="${ZCIMTOOLS_TARGET_DIR:-"/opt/zcimtools"}"
LIBEXECDIR="${ZCIMTOOLS_LIBEXECDIR:-"${PREFIX}/libexec"}"

PROGRAM_NAME="${0##*/}"

# check for input source file
if [ "$#" -ne 1 ]
then
	echo "Usage: $PROGRAM_NAME source-file.plm" 2>&1
	exit 2
fi

if [ ! -f "$1" ]
then
    if [ "$1" = "--help" ]
    then
        echo "Usage: $PROGRAM_NAME source-file.plm"
        exit 0
    else
        echo "ERROR: source file $1 does not exist." 2>&1
        exit 1
    fi
fi

CURRENT_DIRECTORY="$(readlink --canonicalize-existing .)"
SOURCE_FILE="$(readlink --canonicalize-existing "$1")"
SOURCE_BASE="${1##*/}"
TMP_DIRECTORY="$(mktemp -d -t plm80.XXXXXXXXX)" || exit 86
cd "$TMP_DIRECTORY" || exit 86

# figure where source is, assume extension .plm
FN="${SOURCE_BASE%.plm}"

# setup I/O for pass 1
# source read from channel 2
cp "$SOURCE_FILE" fort.2
# channel 1 compiler switches: we use defaults, so just one empty line
echo > fort.1

# run pass 1
if [ -x "${CURRENT_DIRECTORY}/plm81v4" ]
then
    # handle development (local directory) copy
    "${CURRENT_DIRECTORY}/plm81v4"
else
    "${LIBEXECDIR}/plm81v4"
fi

# get listing from channel 12
rm -f "${CURRENT_DIRECTORY}/${FN}.prn"
mv fort.12 "${CURRENT_DIRECTORY}/${FN}.prn"

if [ -f fort.16 ] && [ -f fort.17 ]
then
    # setup I/O for pass 2
    # get output files from pass 1 into place
    mv fort.16 fort.4
    mv fort.17 fort.7
    # channel 1 compiler switches: we use defaults, so just one empty line
    echo > fort.1

    # run pass 2
    if [ -x "${CURRENT_DIRECTORY}/plm82v4" ]
    then
        # handle development (local directory) copy
        "${CURRENT_DIRECTORY}/plm82v4"
    else
        "${LIBEXECDIR}/plm82v4"
    fi

    # get hex output from channel 17
    if [ -f fort.17 ]
    then
	    rm -f "${CURRENT_DIRECTORY}/${FN}.hex"
	    mv fort.17 "${CURRENT_DIRECTORY}/${FN}.hex"
        RET=0
    else
	    echo "ERROR: too many errors in pass 1" 2>&1
        RET=1
    fi
else
    echo "ERROR: pass 1 did not produce any output files." 2>&1
    RET=1
fi

# clean up
cd "${CURRENT_DIRECTORY}" || exit 86
rm --recursive --force "${TMP_DIRECTORY}"
exit "$RET"
