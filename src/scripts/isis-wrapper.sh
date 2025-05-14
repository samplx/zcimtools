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

# wrapper script to allow an ISIS Operating System program
# to be executed from the command-line on a linux system.

PREFIX="${ZCIMTOOLS_TARGET_DIR:-"/opt/zcimtools"}"
BINDIR="${ZCIMTOOLS_BINDIR:-"${PREFIX}/bin"}"
DATADIR="${ZCIMTOOLS_DATADIR:-"${PREFIX}/share"}"
ISIS_DATADIR="${ZCIMTOOLS_ISIS_DATADIR:-"${DATADIR}/isis-wrapper"}"
THAMES="${ZCIMTOOLS_THAMES:-"${BINDIR}/thames"}"
PROGRAM_NAME="@@PROGRAM_NAME@@"
PROGRAM_VERSION="@@PROGRAM_VERSION@@"

ISIS_F0="$(pwd)"
if [ "$PROGRAM_VERSION" = "z80pack" ]
then
    ISIS_F1="${ISIS_DATADIR}/z80pack"
else
    ISIS_F1="${ISIS_DATADIR}/${PROGRAM_NAME}/${PROGRAM_VERSION}"
fi
ISIS_F2="${ISIS_DATADIR}/lib/2.1"
ISIS_F3="${ISIS_DATADIR}/z80pack"
export ISIS_F0 ISIS_F1 ISIS_F2 ISIS_F3

if [ ! -x "${THAMES}" ]
then
    echo "ERROR: ISIS program runner $THAMES not found" 2>&1
    exit 127
fi

#echo "${THAMES} ${PROGRAM_NAME} $*"

exec "${THAMES}" ":F1:${PROGRAM_NAME}" "$@"

