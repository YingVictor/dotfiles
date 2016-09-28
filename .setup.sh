git clone --no-checkout git@github.com:YingVictor/dotfiles.git $HOME/.dotfiles
if [ $? != 0 ]; then
    return 1
fi

alias dotfiles='git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'

function mvp ()
{
  dir="$2"
  last_char="${dir: -1}"
  [ "$last_char" != "/" ] && dir="$(dirname "$2")"
  [ -d "$dir" ] || mkdir -p "$dir" && mv "$@"
}

dotfiles checkout
if [ $? == 0 ]; then
    echo "Checked out dotfiles."
else
    echo "Backing up pre-existing dotfiles."
    BACKUP_DIR=$HOME/.backup
    mkdir -p $BACKUP_DIR && \
        dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
        xargs -I{} mvp {} $BACKUP_DIR/{}
    dotfiles checkout
fi
