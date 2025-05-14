#!/bin/bash
#
#	Copyright 2024 James Burlingame
#
#	Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	    https://www.apache.org/licenses/LICENSE-2.0
#
#	Unless required by applicable law or agreed to in writing, software
#	distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#	See the License for the specific language governing permissions and
#	limitations under the License.
#

# wrapper script to convert a CP/M program into something
# that can be executed from the BASH command-line.

PREFIX="${ZCIMTOOLS_TARGET_DIR:-"/opt/zcimtools"}"
BINDIR="${ZCIMTOOLS_BINDIR:-"${PREFIX}/bin"}"
DATADIR="${ZCIMTOOLS_DATADIR:-"${PREFIX}/share"}"
CPM_DATADIR="${ZCIMTOOLS_CPM_DATADIR:-"${DATADIR}/cpm-wrapper"}"
ZXCC="${ZCIMTOOLS_ZXCC:-"${BINDIR}/zxcc"}"
PROGRAM_NAME="${0##*/}"

if [ ! -x "${ZXCC}" ]
then
    echo "ERROR: CP/M runner $ZXCC not found" 2>&1
    exit 127
fi

if [ -f "${CPM_DATADIR}/${PROGRAM_NAME}.com" ]
then
    CPM_PROGRAM_NAME="${CPM_DATADIR}/${PROGRAM_NAME}.com"
elif [ -f "${CPM_DATADIR}/${PROGRAM_NAME}" ]
then
    CPM_PROGRAM_NAME="${CPM_DATADIR}/${PROGRAM_NAME}"
else
    echo "ERROR: CP/M program ${PROGRAM_NAME} not found" 2>&1
    exit 127
fi

#echo "${ZXCC} ${CPM_PROGRAM_NAME} $*"

exec ${ZXCC} "${CPM_PROGRAM_NAME}" "$@"

