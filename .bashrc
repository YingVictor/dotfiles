# ~/.bashrc: executed by bash(1) for interactive shells.


# This file sources a system-wide bashrc file, which:
#      - sets up standard environment variables
#      - sources user file ~/.bash_environment, if it exists
#      - sets standard path
#      - sets up standard shell variables, aliases, etc.
#      - source user file ~/.bashrc.mine, if it exists

initdir=/usr/athena/lib/init

if [ -r $initdir/bashrc ]; then
        . $initdir/bashrc
else
	if [ -n "$PS1" ]; then
	  echo "Warning: System-wide initialization files not found."
	  echo "Shell initialization has not been performed."
	  stty sane
	fi
	# set some basic defaults if failed initialization
	umask 077
fi

# If you want to ADJUST the bash initialization sequence, create any of 
# the following files (as appropriate) in your home directory, with commands
# to achieve the effect listed:
#
#      .bash_environment - setup session environment (set environmental
#			   variables, attach lockers, etc.)
#      .bashrc.mine  - setup bash environment (set shell variables, aliases,
#                     unset system defaults, etc.)
                      
# If you want to CHANGE the bash initialization sequence, revise this .bashrc
# file (the one you're reading now).  You may want to copy the contents of
# the system-wide bashrc file as a starting point.
# 
# WARNING: If you revise this .bashrc file, you will not automatically
# get any changes that Athena may make to the system-wide file at a
# later date.  Be sure you know what you are doing.


# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return


# Miscellaneous shell options
# See man bash for more options...

# Don't wait for job termination notification
set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# Check the window size after each command
shopt -s checkwinsize

#Fail when overwritting file unless explicitly forced
set -o noclobber


# Glob options

# Enable regular expression globs
shopt -s extglob

# The pattern "**" in a pathname expansion will match all files
# and zero or more directories and subdirectories.
shopt -s globstar

# If a pattern fails to match, report an error
#shopt -s failglob

# Include hidden files
shopt -s dotglob

# Exclude . and .. from matches
GLOBIGNORE=${GLOBIGNORE:+$GLOBIGNORE:}.:..

# Use case-insensitive filename globbing
# shopt -s nocaseglob


# Completion options

# These completion tuning parameters change the default behavior of bash_completion:

# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1

# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1

# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [ -x /usr/bin/mint-fortune ]; then
     /usr/bin/mint-fortune
fi

# Custom completion
if [ -d ${HOME}/.bash/completion ]; then
  for file in  ${HOME}/.bash/completion/*; do
    source $file
  done
fi


# History Options

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Don't put duplicate lines or lines starting with whitespace in the history.
HISTCONTROL=ignoreboth

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout'
# HISTIGNORE=$'[ \t]*:&:[fb]g:exit:logout:ls' # Ignore the ls command as well

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# Whenever displaying the prompt, write the previous line to disk
PROMPT_COMMAND="history -a"

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# Prompt and title

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm|xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    if [[ ${EUID} == 0 ]] ; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\h\[\033[01;36m\] \W \$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;36m\]\w \$\[\033[00m\] '
    fi
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h \w \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h \w\a\]$PS1"
    ;;
*)
    ;;
esac





# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
umask 022
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077


# Aliases
#
# Some people use a different file for aliases
if [ -f "${HOME}/.bash/aliases" ]; then
  source "${HOME}/.bash/aliases"
fi

# Functions
#
# Some people use a different file for functions
if [ -f "${HOME}/.bash/functions" ]; then
  source "${HOME}/.bash/functions"
fi

# Check if we can use SSH agent.
ssh-add -l >/dev/null 2>&1
if [ $? = 2 ]; then
    # No ssh-agent usable
    # Use existing SSH agent if possible.
    SSH_SCRIPT_DIR="$HOME/.ssh/"
    SSH_SCRIPT=$SSH_SCRIPT_DIR"env.sh"
    if [ -e $SSH_SCRIPT ]; then
        source $SSH_SCRIPT > /dev/null
    fi
    # Check if we can use SSH agent.
    ssh-add -l >/dev/null 2>&1
    if [ $? = 2 ]; then
        # No ssh-agent usable
        # Kill existing ssh-agents
        pkill -u $USER -f ssh-agent

        # Start new SSH agent and record the information to use it in a file
        mkdir -p $SSH_SCRIPT_DIR
        # >| allows output redirection to over-write files if no clobber is set
        ssh-agent -s >| $SSH_SCRIPT
        source $SSH_SCRIPT > /dev/null

        # Add SSH keys
        if [ -d ~/.ssh/keys ]; then
            ssh-add ~/.ssh/keys/id!(*.pub) 2> /dev/null
        elif [ -d ~/.ssh/private ]; then
            ssh-add ~/.ssh/private/id!(*.pub) 2> /dev/null
        else
            ssh-add ~/.ssh/id!(*.pub) 2> /dev/null
        fi
    fi
fi

# Check if we can use X server.
X_SCRIPT="${HOME}/.x_env.sh"
xhost >/dev/null 2>&1
if [ $? != 0 ]; then
  # No X server reachable
  if [ -e $X_SCRIPT ]; then
    source $X_SCRIPT
    # Check if we can use X server.
    xhost >/dev/null 2>&1
    if [ $? != 0 ]; then
      # No X server reachable
      echo "Deleting defunct ${X_SCRIPT}."
      rm $X_SCRIPT
    fi
  fi
else
  if [ -e $X_SCRIPT ]; then
    echo "DISPLAY works, but there is an existing ${X_SCRIPT}."
  else
    echo "export DISPLAY=${DISPLAY}" > $X_SCRIPT
  fi
fi
