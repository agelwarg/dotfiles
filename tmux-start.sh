#!/bin/sh
_new_app_window() {
  tmux new-window -n APP-$1 "ssh -t g01plapp01 sudo -i"
  tmux splitw -h -p 50      "ssh -t g01plapp03 sudo -i"
  tmux splitw -v -p 66      "ssh -t g01plapp04 sudo -i"
  tmux splitw -v -p 50      "ssh -t g01plapp05 sudo -i"
  tmux select-pane -t 0
  tmux splitw -v -p 50      "ssh -t g01plapp02 sudo -i"
  tmux select-pane -t 0
}

_new_db_window() {
  tmux new-window -n DB-$1  "ssh -t g01aldb01 sudo -i"
  tmux splitw -h -p 50      "ssh -t g01aldb03 sudo -i"
  tmux splitw -v -p 50      "ssh -t g01aldb04 sudo -i"
  tmux select-pane -t 0
  tmux splitw -v -p 50      "ssh -t g01aldb02 sudo -i"
  tmux select-pane -t 0
}

_read_password() {
  printf "Enter password:"
  stty_orig=`stty -g`
  stty -echo
  read _password
  stty $stty_orig
}

_send_password() {
  sleep 2
  for _window in $*; do
    tmux select-window -t "${_window}"
    tmux setw synchronize-panes on
    tmux send-keys "${_password}" C-m
    tmux setw synchronize-panes off
  done
}

_send_keys() {
  _cmd="$1"
  shift
  for _window in $*; do
    tmux select-window -t "${_window}"
    tmux setw synchronize-panes on
    tmux send-keys "${_cmd}" C-m
    tmux setw synchronize-panes off
  done

}

_session="KARL"
tmux new -s "${_session}" -d
if [ $? -eq 0 ]; then

  _read_password

  tmux rename-window    vim
  tmux new-window    -n bash
  tmux new-window    -n bash

  _new_app_window 1
  _new_app_window 2

  _new_db_window 1
  _new_db_window 2

  _send_password APP-1 APP-2 DB-1 DB-2
  _send_keys "set -o vi && cd /docker/deploy/prd/prd-01" APP-1 APP-2
  _send_keys "set -o vi && cd /docker/deploy/database" DB-1 DB-2

  tmux select-window -t "vim"
  _send_keys "gpe && vim" vim
  _send_keys ":NERDTree" vim
fi

tmux attach -t "${_session}"
