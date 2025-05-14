#!/bin/bash

SIMH_TARGET_DIR=${SIMH_TARGET_DIR:-"@@SIMH_TARGET_DIR@@"}

if [ -d "$SIMH_TARGET_DIR" ]
then
    cd "$SIMH_TARGET_DIR" || exit 86
    rm -f default
    ln -s "classic" "default"
    echo "Set SIMH to Classic mode"
else
    echo "Warning: unable to switch to SIMH Classic mode" 2>&1
    exit 1
fi

exit 0
