#!/bin/bash

cd $SRC_DIR
DOTFILES=$MYHOME/dotfiles
if [ ! -d $DOTFILES ]; then
	  git clone https://navsan@bitbucket.org/navsan/dotfiles.git 
    ln -sf $PROVISION_DIR/dotfiles $DOTFILES
fi
