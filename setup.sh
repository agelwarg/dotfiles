#!/bin/sh

_dir="$(cd $(dirname $0); pwd)"

# SSH setup
mkdir -p ~/.ssh chmod 700 ~/.ssh
for i in ${_dir}/ssh/*; do
  [ -f ~/.ssh/$(basename $i) ] || cp $i ~/.ssh/$(basename $i)
done

for i in vim vimrc screenrc inputrc; do
  rm -rf ~/.$i && ln -s ${_dir}/$i ~/.$i
done

~/.vim/update_bundles
