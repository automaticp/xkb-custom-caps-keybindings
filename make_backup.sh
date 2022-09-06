#!/bin/bash

#


BACKUP_ROOT="$1"
if [ -z "$BACKUP_ROOT" ]; then
    BACKUP_ROOT=./
fi

if [ ! -d "$BACKUP_ROOT" ]; then
    echo "Error: Specified argument is not a valid directory."
    return
fi

BACKUP_DIR="$BACKUP_ROOT/xkb-backup/"
mkdir -v -p "$BACKUP_DIR"

XKB_DIR=/usr/share/X11/xkb/


create_backup () {
    mkdir -p -v "$BACKUP_DIR/$(dirname "$1")"
    cp -v -r -T "$XKB_DIR/$1" "$BACKUP_DIR/$1"
}

create_backup "types/"

create_backup "compat/"

create_backup "symbols/"
