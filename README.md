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

If running on BASH or a compatible shell:
 - Run nix-cfg/vim/make-vim-symlinks.sh

Otherwise
 - 

nix-cfg/
nix-cfg/bash
nix-cfg/bash/bashrc
nix-cfg/bash/bash_aliases

nix-cfg/vim
nix-cfg/vim/vimrc
nix-cfg/vim/dotvim
nix-cfg/vim/dotvim/colors
nix-cfg/vim/dotvim/colors/jellybeans.vim

nix-cfg/i3
nix-cfg/i3/config

src/
src/check-version
src/pydev
src/nwping
src/apt-build-dep-clean
src/lnall

TODO
===

 - [X] add commonly used plugins to dotvim
 - [X] use pathogen, to manage vim plugins?
 - [ ] write a makefile or script to deploy all the files using symlinks 

