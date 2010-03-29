# e - a wrapper script to call $EDITOR with redirection support

## Usage

- You must be invoking the editor hundreds of times everyday.
  Why waste types?  Even `vi' is too long for you.

  $ e anyfile

- Sometimes you want to open the result of a command with your editor.

  $ git diff | e

- And save the result of an edit.

  $ git diff | e > annotated_patch

- Run a script as soon as you write it.

  $ e test.pl | perl
