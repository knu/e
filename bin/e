#!/bin/sh
#
# e(1) - a smart wrapper for $EDITOR
#
# Copyright (c) 2009, 2010, 2011, 2012 Akinori MUSHA
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.

VERSION="0.1.1"

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

editor_progname () {
    local arg

    for arg; do
        case "$arg" in
            *'='*|*/env|env)
                continue
                ;;
            *)
                echo "${arg##*/}"
                ;;
        esac
    done
}

main () {
    local first_file file pos line

    if [ -z ${EDITOR+1} ]; then
        echo EDITOR must be set. >&2
        exit 255
    fi

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
        case "$pos" in
            /*)
                case "$(editor_progname $EDITOR)" in
                    *vi|*vim)
                        set -- "+$pos" "$@"
                        ;;
                    *)
                        line="$(grep -En "${pos#/}" "$first_file" | head -n1)"
                        if [ -n "$line" ]; then
                            set -- "+${line%:*}" "$@"
                        fi
                        ;;
                esac
                ;;
            *)
                set -- "+$pos" "$@"
                ;;
        esac
    fi

    if [ -z "$output" -a -z "$tmpfile" ]; then
        exec $EDITOR "$@"
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
