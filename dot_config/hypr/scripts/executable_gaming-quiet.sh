#!/bin/sh
# Silence Noctalia while the gaming workspace is visible.
#   gaming-quiet.sh on   -> OSD popups off, notifications Do Not Disturb
#   gaming-quiet.sh off  -> OSD back on, previous DND state restored
# Called from autostart.lua on workspace changes.
state="${XDG_RUNTIME_DIR:-/tmp}/gaming-quiet-dnd"

case "$1" in
    on)
        [ -f "$state" ] || noctalia msg notification-dnd-status > "$state"
        noctalia msg osd-disable
        noctalia msg notification-dnd-set on
        ;;
    off)
        noctalia msg osd-enable
        if [ -f "$state" ]; then
            noctalia msg notification-dnd-set "$(cat "$state")"
            rm -f "$state"
        fi
        ;;
    *)
        echo "usage: $0 on|off" >&2; exit 1
        ;;
esac
