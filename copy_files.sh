#!/bin/bash

XKB_DIR=/usr/share/X11/xkb/

create_copy () {
    cp -v -T "$1" "$XKB_DIR/$1"
}

create_copy compat/*

create_copy symbols/*

create_copy types/*
