#!/bin/bash

XKB_DIR=/usr/share/X11/xkb/

remove_file () {
    rm -v "$XKB_DIR/$1"
}

remove_file compat/custom_caps

remove_file symbols/custom_caps

remove_file types/custom_caps
