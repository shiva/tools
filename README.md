Scripts for *nix and mac environments
---


Scripts
===
 - renfiles - rename spaces with hypens
 - Show env vars
 - Generate C implementation file from header
 - make-vim-symlinks.sh - setup vim 

Deploying vim files
===

 - If running on BASH or a compatible shell, run
 '''
 $ nix-cfg/vim/make-vim-symlinks.sh
 '''
 
 - Otherwise, symlink or copy nix-cfg/vimrc to ~/.vimrc

When opening vim for the first time, it will create a ~/.vim directory, and setup vundle and other plugins.

TODO
===
 - [X] add commonly used plugins to dotvim
 - [X] use pathogen, to manage vim plugins?
 - [ ] write a makefile or script to deploy all the files using symlinks 

