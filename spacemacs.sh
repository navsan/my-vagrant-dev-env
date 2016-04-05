#!/bin/bash

if [ ! -f $MYHOME/.emacs.d/.spacemacs ]; then
	# Install emacs version 24+ first
	if [ $(emacs --version | grep -c "GNU Emacs 24.5") -eq 0 ]; then
		rm -rf $MYHOME/.emacs.d
		#DEBIAN_FRONTEND=noninteractive sudo apt-get build-dep -y emacs24		
		cd $SRC_DIR/
		wget https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
	 	tar zxvf emacs-24.5.tar.gz
		cd emacs-24.5
		./configure
		make -j 4
		sudo checkinstall -Dy --install --pkgname=emacs-24.5
	fi
	
	# Now install spacemacs
	rm -rf $MYHOME/.emacs.d
	git clone https://github.com/syl20bnr/spacemacs $MYHOME/.emacs.d
	ln -sf $DOTFILES/spacemacs/.spacemacs $MYHOME/.spacemacs
	rm -rf $MYHOME/.emacs.d/private
	ln -sf $DOTFILES/spacemacs/private $MYHOME/.emacs.d/private
fi


