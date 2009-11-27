#!/bin/sh
#
# $Id: e 1034 2008-10-17 09:52:11Z knu $

if [ ! -e "$TTY" ]; then
    TTY="$(tty)"
    if [ ! -e "$TTY" ]; then
        TTY=/dev/tty
    fi
fi

tmpfile=
output=

finalize () {
    rm -f "$tmpfile"
}

register_finalizer () {
    trap "finalize; exit 130" 1 2 3 15
}

if [ ! -t 0 ]; then
    tmpfile="$(mktemp /tmp/e.XXXXXX)"
    register_finalizer "$tmpfile"
    cat > "$tmpfile"
    exec < "$TTY"
    set -- "$@" "$tmpfile"
fi

if [ ! -t 1 ]; then
    output=t
    if [ -z "$tmpfile" ]; then
        tmpfile="$(mktemp /tmp/e.XXXXXX)"
        register_finalizer "$tmpfile"
        set -- "$@" "$tmpfile"
    fi
    exec 4>&1 > "$TTY"
fi

case "$1" in
    +[0-9]*)
        ;;
    +*)
        shift; set -- "./$1" "$@"
        ;;
esac

$EDITOR "$@"
ret="$?"

if [ -n "$output" ]; then
    cat "$tmpfile" >&4
fi

finalize
exit "$ret"
