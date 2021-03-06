#!/bin/sh

_dir="$(cd $(dirname $0); pwd)"

# SSH setup
mkdir -p ~/.ssh && chmod 700 ~/.ssh
for i in ${_dir}/ssh/*; do
  if [ ! -f ~/.ssh/$(basename $i) ]; then
    cp $i ~/.ssh/$(basename $i)
  fi
  chmod go-rwx ~/.ssh/$(basename $i)
done
ln -s authorized_keys ~/.ssh/authorized_keys2

for i in vim vimrc screenrc tmux.conf inputrc gitconfig bashrc bashrc.Linux bashrc.Darwin; do
  rm -rf ~/.$i && ln -s ${_dir}/$i ~/.$i
done

~/.vim/update_bundles
