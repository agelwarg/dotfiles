#!/bin/sh

_dir="$(cd $(dirname $0); pwd)"

for i in vim vimrc screenrc inputrc; do
  rm -rf ~/.$i && ln -s ${_dir}/$i ~/.$i
done

~/.vim/update_bundles
