#!/bin/bash

if [ ! -f $MYHOME/.tmux.conf ]; then
    sudo apt-get install -y tmux
    ln -sf $DOTFILES/.tmux.conf $MYHOME/.tmux.conf 
fi

# Setting up powerline
if [ ! -f $MYHOME/.config/powerline/themes ]; then 
	sudo apt-get install -y python-pip 
	cd $SRC_DIR
	su -c 'pip install git+git://github.com/powerline/powerline'
	wget https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf
	sudo mv PowerlineSymbols.otf /usr/share/fonts/
	sudo fc-cache -vf
	sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/

	sudo pip install psutil
	POWERLINE_ROOT=/usr/local/lib/python2.7/dist-packages/powerline
	mkdir -p $MYHOME/.config/powerline/themes
	cp -r $POWERLINE_ROOT/config_files/themes/tmux $MYHOME/.config/powerline/themes/tmux 
	ln -sf $DOTFILES/tmux-powerline.json $MYHOME/.config/powerline/themes/tmux/default.json 
fi 

