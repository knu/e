# e - a smart wrapper for `$EDITOR`

## NAME

`e(1) - a smart wrapper for $EDITOR`

## SYNOPSIS

`e [[+LINENO|+/PATTERN] FILENAME [+LINENO|+/PATTERN]] ...`

## DESCRIPTION

`e(1)` is a smart wrapper for `$EDITOR` written in Bourne shell.  It
enhances any editor with some user friendly features described below.

## ENVIRONMENT

- `EDITOR`

    The command (or command line) wrapped around and invoked by this
    wrapper.

## EXAMPLES

If you have the environment variable `EDITOR` defined, then you are
ready to run `e`.  You can just drop the alias or symlink pointing to
your editor.  `e` is much more than an alias.

- You invoke the editor of your choice hundreds of times everyday, so
  the command name has to be short.  "`vi`" may look fine, but still
  it's one stroke too many.  Start using `e` from now on and save your
  precious time.

        # In your shell's profile
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

        $ grep -lr keyword . | xargs -n1 e

        $ grep -lr keyword . | while read f; do e "$f"; done

- As a bonus for non-vi users, `e` offers support for "`+/PATTERN`" to
  all editors including Emacs.

        # EDITOR="emacsclient -t"
        $ e +/'^main' prog.c
        # Internally calls grep(1) with -E and runs $EDITOR, adding "+LINENO"
        # if found.

- `e` takes a position specifier followed by a file name.  This form
  is exclusively supported by vi variants, but `e` changes the
  parameter order so it works with most editors.

        $ e prog.rb +42
        # Runs `$EDITOR +42 prog.rb`

- `e` understands the "`FILENAME:LINENO`" format, which is converted
  to "`+LINENO FILENAME`" if a file named `FILENAME` exists.

        $ e /path/to/file.rb:1218
        # Runs `$EDITOR +1218 /path/to/file.rb`

## SEE ALSO

[`grep(1)`](http://www.freebsd.org/cgi/man.cgi?query=grep&sektion=1),
[`emacsclient(1)`](http://www.freebsd.org/cgi/man.cgi?query=emacsclient&sektion=1&manpath=FreeBSD+Ports),
[`vi(1)`](http://www.freebsd.org/cgi/man.cgi?query=vi&sektion=1)

## AUTHOR

Copyright (c) 2009, 2010, 2011, 2012 Akinori MUSHA.

Licensed under the 2-clause BSD license.  See `LICENSE.txt` for
details.

Visit [GitHub Repository](https://github.com/knu/e) for the latest
information.
