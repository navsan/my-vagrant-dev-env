#!/bin/bash

sudo apt-get install -y zsh zsh-doc
chsh -s `which zsh` vagrant
if [ ! -d "$MYHOME/.oh-my-zsh" ]; then
	  git clone git://github.com/robbyrussell/oh-my-zsh.git $MYHOME/.oh-my-zsh
fi
cp $MYHOME/.oh-my-zsh/templates/zshrc.zsh-template $MYHOME/.zshrc

# Create a common .myrc to be used by both .bashrc and .zshrc
if [ ! -e $MYHOME/.myrc ]; then
	  echo -e "\n\n## ~/.bashrc is marked READ-ONLY. Use ~/.myrc instead." >> $MYHOME/.bashrc
	  echo "if [ -e ~/.myrc ]; then source ~/.myrc; fi" >> $MYHOME/.bashrc
	  chmod a-w $MYHOME/.bashrc
	  echo -e "\n\n## ~/.zshrc is marked READ-ONLY. Use ~/.myrc instead." >> $MYHOME/.zshrc
	  echo "if [ -e ~/.myrc ]; then source ~/.myrc; fi" >> $MYHOME/.zshrc
	  chmod a-w $MYHOME/.zshrc
	  touch $MYHOME/.myrc
	  chown vagrant $MYHOME/.myrc
	  chmod u+w $MYHOME/.myrc
fi
