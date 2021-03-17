# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
umask 022

# Set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/.local/bin" ] ; then
  PATH="${HOME}/.local/bin:${PATH}"
fi
if [ -d "${HOME}/.bin" ] ; then
  PATH="${HOME}/.bin:${PATH}"
fi
if [ -d "${HOME}/bin" ] ; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
if [ -d "${home}/.local/man" ]; then
  manpath="${home}/.local/man:${manpath}"
fi
if [ -d "${home}/.man" ]; then
  manpath="${home}/.man:${manpath}"
fi

if command -v vim >/dev/null 2>&1; then
  export EDITOR="$(command -v vim)"
elif command -v vi >/dev/null 2>&1; then
  export EDITOR="$(command -v vi)"
fi


# Make sort, grep, etc. behave as expected.
#export LC_ALL=C


# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Make group tools available.
export PYTHONPATH=/data/sanchez/tools/pymodules/lib/python2.7/site-packages
ZSIMDEPSROOT=/data/sanchez/benchmarks/zsim-deps
export PINPATH=$ZSIMDEPSROOT/pin-2.14-71313-gcc.4.4.7-linux
export PIN_HOME=$PINPATH
export LIBCONFIGPATH=$ZSIMDEPSROOT/libconfig-1.4.9/inst/
export POLARSSLPATH=$ZSIMDEPSROOT/polarssl-1.1.4/
export DRAMSIMPATH=$ZSIMDEPSROOT/DRAMSim2/
export ZSIMARMADILLOPATH=$ZSIMDEPSROOT/armadillo/
export ZSIMAPPSPATH=/data/sanchez/benchmarks/zsim-apps/
PATH=$PATH:/usr/local/csail/bin:/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games:$PINPATH
. /data/sanchez/tools/git-2.19/env.sh
. /data/sanchez/tools/ninja-1.7.2/env.sh
. /data/sanchez/tools/go-1.12/env.sh
. /data/sanchez/tools/hugo-0.55/env.sh
. /data/sanchez/tools/llvm-6.0.1-x86_64-linux-gnu-ubuntu-14.04/env.sh

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"
