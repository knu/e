#!/bin/sh
#
# $Id: e 1034 2008-10-17 09:52:11Z knu $

tmpfile=
output=

finalize () {
    rm -f "$tmpfile"
}

register_finalizer () {
    trap "finalize; exit 130" 1 2 3 15
}

is_pos () {
    case "$1" in
        /*)
            [ -n "$2" ]
            return
            ;;
        [1-9]*)
            case "$1" in
                *[!0-9]*)
                    return 1
                    ;;
                *)
                    return 0
                    ;;
            esac
            ;;
    esac

    return 1
}

main () {
    local first_file file pos line

    if [ ! -e "$TTY" ]; then
        TTY="$(tty)"
        if [ ! -e "$TTY" ]; then
            TTY=/dev/tty
        fi
    fi

    if [ $# -ge 1 ]; then
        pos="${1#+}"
        if [ "$pos" != "$1" ] && is_pos "$pos" t; then
            # +123 ...
            shift
        elif pos="${1##*?:}" && [ "$pos" != "$1" ] && is_pos "$pos" &&
            file="${1%":$pos"}" && [ -e "$file" ]; then
            # file:123
            shift
            set -- "$file" "$@"
        elif [ $# -ge 2 -a -e "$1" ] &&
            pos="${2#+}" && [ "$pos" != "$2" ] && is_pos "$pos" t; then
            # file +123
            file="$1"
            shift 2
            set -- "$file" "$@"
        else
            pos=
        fi
    fi

    if [ $# -ge 1 ]; then
        if [ "${1#+}" != "$1" ]; then
            file="./$1"
            shift
            set -- "$file" "$@"
        fi

        first_file="${1:-.}"
    fi

    if [ -z "$first_file" ]; then
        if [ ! -t 0 ]; then
            tmpfile="$(mktemp /tmp/e.XXXXXX)"
            register_finalizer "$tmpfile"
            cat > "$tmpfile"
            exec < "$TTY"
            first_file="$tmpfile"
            set -- "$tmpfile"
        fi

        if [ ! -t 1 ]; then
            output=t
            if [ -z "$tmpfile" ]; then
                tmpfile="$(mktemp /tmp/e.XXXXXX)"
                register_finalizer "$tmpfile"
                first_file="$tmpfile"
                set -- "$tmpfile"
            fi
            exec 4>&1 > "$TTY"
        fi
    else
        if [ ! -t 1 ]; then
            output=t
            exec 4>&1 > "$TTY"
        fi
    fi

    if [ -n "$pos" -a -n "$first_file" ]; then
        case "${EDITOR##*/}" in
            *vi*)
                set -- "+$pos" "$@"
                ;;
            *)
                case "$pos" in
                    /*)
                        line="$(egrep -n "${pos#/}" "$first_file" | head -n1)"
                        if [ -n "$line" ]; then
                            set -- "+${line%:*}" "$@"
                        fi
                        ;;
                    *)
                        set -- "+$pos" "$@"
                        ;;
                esac
                ;;
        esac
    fi

    $EDITOR "$@"
    ret="$?"

    if [ -n "$output" ]; then
        cat "$first_file" >&4
    fi

    finalize
    exit "$ret"
}

main "$@"
