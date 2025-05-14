#!/bin/bash

S_PREFIX="${YAZE_AG_TARGET_DIR:-"/opt/yaze-ag"}"
S_BINDIR="${S_PREFIX}/bin"
S_YAZEFILES="${S_PREFIX}/lib"
S_CPMDSKS="${S_PREFIX}/lib/disks"
S_YAZE_AG_DIR="$HOME/cpm"

if [ ! -f .yazerc ]
then
    if [ ! -d "$S_YAZE_AG_DIR" ]
    then
        echo
        echo "Creating $S_YAZE_AG_DIR ..."
        echo
        mkdir -p "$S_YAZE_AG_DIR" || exit 86
        echo "copy $S_CPMDSKS/yazerc  to  $S_YAZE_AG_DIR/.yazerc"
        cp "$S_CPMDSKS/yazerc" "$S_YAZE_AG_DIR/.yazerc"
        echo
        echo "copy $S_YAZEFILES/*.ktt  to  $S_YAZE_AG_DIR/"
        echo
        cp -v "$S_YAZEFILES"/*.ktt "$S_YAZE_AG_DIR"
        echo
        echo "Install some yaze-disks to run CP/M 3.1 ..."
        echo
        for ydsk in "$S_CPMDSKS"/*.gz ; do
            ydsk_name="$(basename "$ydsk" .gz)"
            printf '%s <----' "$ydsk_name"
            gzip -vdc "$ydsk" > "$S_YAZE_AG_DIR/$ydsk_name"
        done
        cd "$S_YAZE_AG_DIR" || exit 86
        tar xf disksort.tar
        rm disksort.tar
    fi
    cd "$S_YAZE_AG_DIR" || exit 86
    if [ ! -f .yazerc ]
    then
        echo "ERROR: $S_YAZE_AG_DIR exists but $S_YAZE_AG_DIR/.yazerc configuration file is missing" 2>&1
        exit 1
    fi
fi

#echo "pwd=$(pwd)"

if [ -x yaze_bin ]
then
    echo "starting ./yaze_bin $*"
    exec ./yaze_bin "$*"
else
    echo "starting yaze_bin $*"
    exec "${S_BINDIR}/yaze_bin" "$*"
fi
