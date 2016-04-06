#!/bin/bash

if [ ! -f $MYHOME/.tmux.conf ]; then
    sudo apt-get install -y tmux
    ln -sf $DOTFILES/.tmux.conf $MYHOME/.tmux.conf 
fi
