#!/bin/bash

if [ ! -f $MYHOME/.tmux.conf ]; then
    sudo apt-get install -y tmux
    ln -sf $DOTFILES/.tmux.conf $MYHOME/.tmux.conf 
    echo "alias tmux=\"tmux -2\"" >> $MYHOME/.myrc  # 256 color support
fi
