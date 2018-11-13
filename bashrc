# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

set -o vi

unset PROMPT_COMMAND

EDITOR=vim
export EDITOR

_os=$(uname -s)
for _bashrc in ".bashrc.${_os}" .bashrc.local; do
  [ -f "$HOME/${_bashrc}" ] && source "$HOME/${_bashrc}"
done

# Build PATH
PATH=$BASE_PATH
PATH=$PATH:/usr/local/bin
PATH=$PATH:$HOME/src/scripts
PATH=$PATH:$HOME/bin

# rbenv
PATH=$PATH:$HOME/.rbenv/bin
export PATH
eval "$(rbenv init -)"

# User specific aliases and functions
alias vim='TERM=xterm-256color vim'

u () { bundle exec rake database:migrate:force:up file=$1; }
d () { bundle exec rake database:migrate:force:down file=$1; }
