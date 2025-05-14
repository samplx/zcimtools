#!/bin/bash

#
# UNIX Driver for Intel 8080 Cross Emulator
#
# October 2007, Udo Munk
# August 31, 2024, modified to run under docker(debian). Jim Burlingame
#
# Usage:
#	batch:    i80 file.cmd file.hex
#	console:  i80 file.hex
#
# file.cmd = command file with emulator commands
# file.hex = Intel hex file with program to run
#
# Assumes that input files are in current directory and assumes that
# program file has extension .hex
#

PREFIX="${ZCIMTOOLS_TARGET_DIR:-"/opt/zcimtools"}"
LIBEXECDIR="${ZCIMTOOLS_LIBEXECDIR:-"${PREFIX}/libexec"}"

PROGRAM_NAME="${0##*/}"

#check for input files
if [ "$#" -ne 1 ] && [ "$#" -ne 2 ]
then
	echo "Usage: $PROGRAM_NAME cmd-file hex-file or $PROGRAM_NAME hex-file" 2>&1
	exit 2
fi
if [ "$#" -eq 1 ]
then
    if [ "$1" = "--help" ]
    then
		echo "Usage: $PROGRAM_NAME cmd-file hex-file or $PROGRAM_NAME hex-file"
        exit 0
    elif [ ! -f "$1" ]
	then
        echo "ERROR: hex program file $1 does not exist." 2>&1
        exit 1
    fi
	SOURCE_FILE="$(readlink --canonicalize-existing "$1")"
	SOURCE_BASE="${1##*/}"
	FN="${SOURCE_BASE%.hex}"
else
	if [ ! -f "$1" ]
	then
        echo "ERROR: command file $1 does not exist." 2>&1
		exit 1
	fi
	CONTROL_FILE="$(readlink --canonicalize-existing "$1")"
	if [ ! -f "$2" ]
	then
        echo "ERROR: hex program file $2 does not exist." 2>&1
		exit 1
	fi
	SOURCE_FILE="$(readlink --canonicalize-existing "$2")"
	SOURCE_BASE="${2##*/}"
	FN="${SOURCE_BASE%.hex}"
fi

CURRENT_DIRECTORY="$(readlink --canonicalize-existing .)"
TMP_DIRECTORY="$(mktemp -d -t interp80.XXXXXXXXX)" || exit 86
cd "$TMP_DIRECTORY" || exit 86

# setup files for I/O
# commands read from channel 1
# program read from channel 14, use LOAD 6 6. in command file!
if [ "$#" -eq 2 ]
then
	cp "$CONTROL_FILE" fort.1
	cp "$SOURCE_FILE" fort.14
else
	cat > fort.1 <<!!EOF
\$O=2
LOAD 6 6.
\$I=2
!!EOF
	cp "$SOURCE_FILE" fort.14
fi

# run emulation
if [ -x "$CURRENT_DIRECTORY/interp80" ]
then
    # handle development (local directory) copy
    "$CURRENT_DIRECTORY/interp80"
else
    "${LIBEXECDIR}/interp80"
fi

# get output file if batch mode
if [ "$#" -eq 2 ] && [ -f fort.2 ]
then
	rm -f "${CURRENT_DIRECTORY}/${FN}.out"
	mv fort.2 "${CURRENT_DIRECTORY}/${FN}.out"
fi


# clean up
cd "${CURRENT_DIRECTORY}" || exit 86
rm --recursive --force "${TMP_DIRECTORY}"

exit 0
