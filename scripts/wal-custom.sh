#!/usr/bin/env bash
wal -n -i "$@"

nitrogen --head=0 --set-auto "$( < "$HOME/.cache/wal/wal")"
nitrogen --head=1 --set-zoom-fill "$( < "$HOME/.cache/wal/wal")"
