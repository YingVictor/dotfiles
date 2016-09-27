git clone --bare git@github.com:YingVictor/dotfiles.git $HOME/.dotfiles
if [ $? != 0 ]; then
    return 1
fi

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

dotfiles checkout
if [ $? == 0 ]; then
    echo "Checked out dotfiles."
else
    echo "Backing up pre-existing dotfiles."
    mkdir -p $HOME/.dotfiles-backup && \
        dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
        xargs -I{} mv {} $HOME/.dotfiles-backup/{}
    dotfiles checkout
fi
