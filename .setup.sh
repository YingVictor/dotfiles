#! /usr/bin/env bash

set -e

git clone --no-checkout git@github.com:YingVictor/dotfiles.git $HOME/.dotfiles

DOTFILES='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

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
