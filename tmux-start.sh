#!/bin/sh
_new_app_window() {
  tmux new-window -n APP-$1 "ssh -t g01plapp01 sudo -i"
  tmux splitw -h -p 50      "ssh -t g01plapp04 sudo -i"
  tmux splitw -v -p 50      "ssh -t g01plapp05 sudo -i"
  tmux select-pane -t 0
  tmux splitw -v -p 66      "ssh -t g01plapp02 sudo -i"
  tmux splitw -v -p 50      "ssh -t g01plapp03 sudo -i"
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

  # Send sudo password
  _send_password APP-1 APP-2 DB-1 DB-2

  # Init app windows
  for _window in APP-1 APP-2; do
    tmux select-window -t "${_window}"
    tmux select-pane -t 0
    tmux send-keys "set -o vi && cd /docker/deploy/dev/dev-01" C-m
    for _pane in 1 2 3 4; do
      tmux select-pane -t ${_pane}
      tmux send-keys "set -o vi && cd /docker/deploy/prd/prd-01" C-m
    done
    tmux select-pane -t 0
  done

  # Init database windows
  for _window in DB-1 DB-2; do
    tmux select-window -t "${_window}"
    tmux select-pane -t 0
    tmux send-keys "set -o vi && cd /docker/deploy/database/g01pldb01" C-m
    tmux select-pane -t 1
    tmux send-keys "set -o vi && cd /docker/deploy/database/g01pldb02" C-m
    tmux select-pane -t 2
    tmux send-keys "set -o vi && cd /docker/deploy/database/g01pldb03" C-m
    tmux select-pane -t 3
    tmux send-keys "set -o vi && cd /docker/deploy/database/g01dldb01" C-m
    tmux select-pane -t 0
  done

  # Start vim
  tmux select-window -t "vim"
  tmux send-keys "gpe && vim" C-m
  tmux send-keys ":NERDTree" C-m
fi

tmux attach -t "${_session}"
