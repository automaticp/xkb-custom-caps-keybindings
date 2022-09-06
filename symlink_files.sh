#!/bin/bash

XKB_DIR=/usr/share/X11/xkb/

create_symlink () {
    ln -s -r -T "$1" "$XKB_DIR/$1"
}

create_symlink compat/custom_caps

create_symlink symbols/custom_caps

create_symlink types/custom_caps
