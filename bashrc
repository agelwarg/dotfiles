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

PATH=$PATH:/usr/local/bin:$HOME/src/scripts:$HOME/bin
[ -z "${BASE_PATH}" ] && export BASE_PATH=$PATH
goto () {
  cd ${1}
  _base="$(pwd)"
  export PATH="${BASE_PATH}"
  export PATH="$HOME/src/gpe-server/vendor/ruby/bin:${PATH}" # ruby
  export PATH="${_base}/BUILD:${PATH}" # agents
  export PATH="${_base}/bin:${_base}/vendor/ruby/bin:${_base}/node_modules/.bin:${PATH}" # server
}

# User specific aliases and functions
alias vim='TERM=xterm-256color vim'

u () { rake database:migrate:force:up file=$1; }
d () { rake database:migrate:force:down file=$1; }
