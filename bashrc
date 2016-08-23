# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

unset PROMPT_COMMAND

EDITOR=vim
export EDITOR

PATH=~/ruby/bin:$PATH
export PATH

_os=$(uname -s)
[ -f ~/.bashrc.${_os} ] && source ~/.bashrc.${_os}
[ -f ~/.bashrc.local ]  && source ~/.bashrc.local

[ -z "${BASE_PATH}" ] && export BASE_PATH=$HOME/src/scripts:$PATH:/usr/local/bin
goto () {
  cd ${1}
  _base="$(pwd)"
  export PATH="${BASE_PATH}"
  export PATH="$HOME/src/gpe-server/vendor/ruby/bin:${PATH}" # ruby
  export PATH="${_base}/BUILD:${PATH}" # agents
  export PATH="${_base}/bin:${_base}/vendor/ruby/bin:${_base}/node_modules/.bin:${PATH}" # server
}

# User specific aliases and functions
alias ls='ls --color=auto'
alias vim='TERM=xterm-256color vim'

u () { rake database:migrate:force:up file=$1; }
d () { rake database:migrate:force:down file=$1; }
