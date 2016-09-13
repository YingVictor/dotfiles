alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare git@github.com:YingVictor/dotfiles.git $HOME/.dotfiles
mkdir $HOME/.config-backup && \
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
    xargs -I{} mv {} $HOME/.config-backup/{}
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
