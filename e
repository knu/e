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

# parse options here

has_filename=
output_file=

case "$1" in
    +[0-9]*)
        if [ $# -ge 2 ]; then
            output_file="$2"
            has_filename=t
        fi
        ;;
    +*)
        output_file="./$1"
        shift
        set -- "$output_file" "$@"
        has_filename=t
        ;;
    *)
        if [ $# -ge 1 ]; then
            output_file="$1"
            has_filename=t
        fi
        ;;
esac

if [ -z "$has_filename" ]; then
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
        output_file="$tmpfile"
        exec 4>&1 > "$TTY"
    fi

else
    if [ ! -t 1 ]; then
        output=t
        exec 4>&1 > "$TTY"
    fi
fi

$EDITOR "$@"
ret="$?"

if [ -n "$output" ]; then
    cat "$output_file" >&4
fi

finalize
exit "$ret"
