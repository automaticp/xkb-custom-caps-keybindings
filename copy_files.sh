#!/bin/bash

XKB_DIR=/usr/share/X11/xkb/

create_copy () {
    cp -v -T "$1" "$XKB_DIR/$1"
}

create_copy compat/custom_caps

create_copy symbols/custom_caps

create_copy types/custom_caps
