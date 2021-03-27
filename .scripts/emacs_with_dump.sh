#!/usr/bin/env bash

readonly DUMP_FILE=~/.emacs.d/.cache/dumps/spacemacs.pdmp

if test -f "$DUMP_FILE"; then
    /snap/bin/emacs --dump-file "$DUMP_FILE" "$@"
else
    /snap/bin/emacs --force-dump "$@"
fi
