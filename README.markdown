# e - a wrapper script to call $EDITOR with redirection support

## Usage

- You invoke the editor of your choice hundreds of times everyday.
  Why not save typing?  `emacs` is way too long, even `vi` is one too
  many.  Start using `e` from now on.

        $ e anyfile

- Sometimes you want to open the output of a command with the editor.

        $ git diff | e

- And save the result of an edit.

        $ git diff | e > annotated.patch

- Run a script as soon as you finish writing it.

        $ e test.pl | perl

* When running an editor in the middle of pipes and redirection, you
  normally need to add `` <`tty` `` and/or `` >`tty` `` to connect the
  editor to the current terminal, but with `e` you can just forget
  about it.

        $ grep -lr keyword . | xargs -n1 e`

        $ grep -lr keyword . | while read f; do e "$f"; done
