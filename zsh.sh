#!/bin/bash

sudo apt-get install -y zsh zsh-doc
chsh -s `which zsh` vagrant
if [ ! -d "$MYHOME/.oh-my-zsh" ]; then
	  git clone git://github.com/robbyrussell/oh-my-zsh.git $MYHOME/.oh-my-zsh
fi
ln -sf $DOTFILES/.zshrc $MYHOME/.zshrc 
ln -sf $DOTFILES/nav.zsh-theme $MYHOME/.oh-my-zsh/themes/nav.zsh-theme

# Mark .bashrc read-only 
echo -e "\n\n## ~/.bashrc is marked READ-ONLY. Use ~/.zshrc instead." >> $MYHOME/.bashrc
chmod a-w $MYHOME/.bashrc

