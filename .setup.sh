#! /usr/bin/env bash

set -e

if [ ! -d $HOME/.dotfiles ] ; then
  git clone --no-checkout git@github.com:YingVictor/dotfiles.git $HOME/.dotfiles
fi

DOTFILES="git --git-dir="$HOME"/.dotfiles/.git --work-tree="$HOME

$DOTFILES status >/dev/null 2>&1
if [ $? != 0 ]; then
  echo "Dotfiles repo not set up properly."
  return
fi

function mvp ()
{
  dir="$2"
  last_char="${dir: -1}"
  [ "$last_char" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] || mkdir -p "$dir" && mv "$@"
}
export -f mvp

set +e

$DOTFILES checkout -q
if [ $? != 0 ]; then
    echo "Backing up pre-existing dotfiles."
    BACKUP_DIR=$HOME/.backup
    mkdir -p $BACKUP_DIR && \
        $DOTFILES checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
        xargs -I{} bash -c "mvp {} $BACKUP_DIR/{}"
    set -e
    $DOTFILES checkout -q
fi

unset mvp

echo "Checked out dotfiles."
