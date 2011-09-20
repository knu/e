# e - a wrapper script for `$EDITOR`

## NAME

`e(1) - a wrapper script for $EDITOR`

## SYNOPSIS

`e [[+LINENO|+/PATTERN] FILENAME [+LINENO|+/PATTERN]] ...`

## DESCRIPTION

`e(1)` is a wrapper script for `$EDITOR` written in Bourne shell.  It
enhances any editor with some neat features described below.

## USAGE

If you have the environment variable `EDITOR`, then you are ready to
run `e`.  You can just drop the alias or symlink pointing to your
editor.  `e` is much more than an alias.

- You invoke the editor of your choice hundreds of times everyday, so
  the command name has to be short.  "`vi`" looks fine, but still it's
  one stroke too many.  Start using `e` from now on and save your
  precious time.

        # EDITOR=vi; export EDITOR

        $ e anyfile

- `e` takes input from stdin so you can open the output of a command
  with the editor.

        $ git diff | e

- `e` prints the edited content if so requested.

        $ e test.pl | perl

- Combining the above two, you can use `e` as a filter in which you
  can edit an intermediate output just as you want.

        $ git diff | e > annotated.patch

- As you may have noticed, with `e` you can forget about adding
  `` <`tty` `` and/or `` >`tty` `` around even if you are in the
  middle of pipes and redirection.

        $ grep -lr keyword . | xargs -n1 e`

        $ grep -lr keyword . | while read f; do e "$f"; done

- As a bonus for non-vi users, `e` offers support for "`+/PATTERN`"
  to non-vi editors like Emacs, etc..

        # EDITOR="emacsclient -t"
        $ e +/'^main' prog.c
        # Internally calls egrep(1) and runs $EDITOR, adding "+LINENO"
        # if found.

- `e` makes a postfixed position specifier prefixed so it works
  with Emacs, etc..

        $ e prog.rb +42
        # Runs `$EDITOR +42 prog.rb`

- `e` understands the "`FILENAME:LINENO`" format, which is
  converted to "`+LINENO FILENAME`" if a file named `FILENAME` exists.

        $ e /path/to/file.rb:1218
        # Runs `$EDITOR +1218 /path/to/file.rb`

## ENVIRONMENT

- `EDITOR`

        The command (or command line) `e(1)` invokes.

## AUTHOR

Copyright (c) 2009, 2010, 2011 Akinori MUSHA.

Licensed under the 2-clause BSD license.  See `LICENSE.txt` for
details.

Visit [GitHub Repository](https://github.com/knu/e) for the latest
information.
