#! /usr/bin/env bash
shopt -s extglob

# mkdir ~/.ssh
# chmod 700 ~/.ssh
#
# ssh-keygen -t rsa -b 4096
#
# wget https://raw.githubusercontent.com/VictorYing/dotfiles/master/.setup.sh
# chmod +x .setup.sh
# ./.setup.sh

ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
    # No ssh-agent usable
    # Use existing SSH agent if possible.
    SSH_SCRIPT_DIR="$HOME/.ssh/"
    SSH_SCRIPT="${SSH_SCRIPT_DIR}${HOSTNAME}_env.sh"
    if [ -e $SSH_SCRIPT ]; then
        source $SSH_SCRIPT > /dev/null
    fi
    # Check if we can use SSH agent.
    ssh-add -l >/dev/null 2>&1
    if [ $? = 2 ]; then
        # No ssh-agent usable
        echo "Starting new SSH agent"

        # Kill existing ssh-agents
        pkill -u $USER -f ssh-agent

        # Start new SSH agent and record the information to use it in a file
        mkdir -p $SSH_SCRIPT_DIR
        # >| allows output redirection to over-write files if no clobber is set
        ssh-agent -s >| $SSH_SCRIPT
        source $SSH_SCRIPT > /dev/null

        # Add SSH keys
        if [ -d ~/.ssh/keys ]; then
            chmod 600 ~/.ssh/keys/id!(*.pub) 2> /dev/null
            ssh-add ~/.ssh/keys/id!(*.pub) 2> /dev/null
        elif [ -d ~/.ssh/private ]; then
            chmod 600 ~/.ssh/private/id!(*.pub) 2> /dev/null
            ssh-add ~/.ssh/private/id!(*.pub) 2> /dev/null
        else
            chmod 600 ~/.ssh/id!(*.pub) 2> /dev/null
            ssh-add ~/.ssh/id!(*.pub) 2> /dev/null
        fi
    fi
fi
ssh-add -l
if [ $? = 1 ]; then
  exit 1
fi

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
        xargs -I{} bash -c "mvp $HOME/{} $BACKUP_DIR/{}"
    set -e
    $DOTFILES checkout -q
    shopt -s dotglob
    for FILENAME in $HOME/.backup/*; do
        FILENAME=$(basename ${FILENAME})
        if diff -q $HOME/$FILENAME $HOME/.backup/$FILENAME; then
            echo "Preexisting ${FILENAME} matches, deleting backup."
            rm -rf $HOME/.backup/$FILENAME
        fi
    done
fi

unset mvp

echo "Checked out dotfiles."
