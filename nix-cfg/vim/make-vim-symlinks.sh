#!/bin/bash

dir=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

echo $dir

dest_dotvim="~/.vim"
if [ -d ${dest_dotvim} ]; then
  # make a copy 
  echo "Making a backup of existing .vim"
  mv ${dest_dotvim} ~/dotvim.bkp
fi

echo "Making symlink for .vim"
ln -s ${dir}/dotvim ~/.vim

dest_vimrc="~/.vimrc"

if [ -f ${dest_vimrc} ]; then
  # make a copy
  echo "Making a backup of existing .vimrc"
  mv ${dest_vimrc} ~/vimrc.bkp
fi

echo "Making symlink for .vimrc"
ln -s ${dir}/vimrc ~/.vimrc

