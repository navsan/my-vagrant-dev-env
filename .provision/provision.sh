#!/bin/bash
set -e 
set -x 

PROVISION_DIR=/vagrant/.provision
MYHOME=/home/vagrant
sudo apt-get update -y

# Install development prerequisites
sudo apt-get install -y autotools-dev autoconf build-essential cmake gdb \
	git-core python

# Download dotfiles 
cd $PROVISION_DIR
if [ ! -d "dotfiles" ]; then
	git clone https://navsan@bitbucket.org/navsan/dotfiles.git 
fi
DOTFILES=$MYHOME/dotfiles
ln -sf $PROVISION_DIR/dotfiles $DOTFILES

# Install zsh
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

# Install tmux
sudo apt-get install -y tmux
ln -sf $DOTFILES/.tmux.conf $MYHOME/.tmux.conf 
echo "alias tmux=\"tmux -2\"" >> $MYHOME/.myrc  # 256 color support

# Install vim from source
if [ $(vim --version | grep -c "Compiled by vagrant") -eq 0 ]; then
	sudo apt-get -y install clang cscope python-dev
	mkdir -p $MYHOME/Programming
	git clone https://github.com/vim/vim.git $MYHOME/Programming/vim
	cd $MYHOME/Programming/vim
	PY_CONFIG=`echo "import sysconfig as s; print s.get_config_var('LIBPL')" | python`
	./configure --enable-cscope --with-features=huge --enable-pythoninterp --with-python-config-dir=$PY_CONFIG
	make -j 4
	sudo make install
	sudo mv `which vi` `which vi`.bkp
	sudo ln -s /usr/local/bin/vim /usr/local/bin/vi
	sudo chmod +x /usr/local/bin/vi
fi

# Set up Vundle
if [ ! -d "$MYHOME/.vim/bundle/Vundle.vim" ]; then
	mkdir -p $MYHOME/.vim/bundle
	chown -R vagrant $MYHOME/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git $MYHOME/.vim/bundle/Vundle.vim
fi


cd $MYHOME/Programming/vim
if [ ! -d "vim-wasabi-colorscheme" ]; then 
	git clone https://github.com/thomd/vim-wasabi-colorscheme.git 
fi
cd vim-wasabi-colorscheme/
mkdir -p $MYHOME/.vim/colors
cp -v colors/* $MYHOME/.vim/colors

#cd ~
ln -sf $DOTFILES/.vimrc $MYHOME/.vimrc
# ex -c ":PluginInstall"
# echo | echo | vim +PluginInstall +qall  &>/dev/null
vim -E -s -c "source $MYHOME/.vimrc" -c PluginInstall -c qa -q /vagrant/vim_error.txt || true
# vim +PluginInstall +qall
# ex -c ":PluginInstall"

if [ ! -d $MYHOME/.vim/bundle/YouCompleteMe ]; then
	mkdir -p $MYHOME/.vim/bundle
	cd $MYHOME/.vim/bundle
	git clone https://github.com/Valloric/YouCompleteMe.git 
	cd $MYHOME/.vim/bundle/YouCompleteMe
	git submodule update --init --recursive
fi
if [ ! -e "$MYHOME/.vim/bundle/YouCompleteMe/third_party/ycmd/ycm_core.so" ]; then
	cd $MYHOME/.vim/bundle/YouCompleteMe
	./install.py --clang-completer
fi



# Install other useful tools
sudo apt-get install -y ack-grep htop 

# Clean up
sudo apt-get autoremove -y


# Trying out spacemacs
sudo apt-get install emacs		## Mainly for the dependencies
cd $MYHOME/Programming/
wget https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
tar zxvf emacs-24.5.tar.gz
cd emacs-24.5
./configure
make -j 3
sudo make install
git clone https://github.com/syl20bnr/spacemacs $MYHOME/.emacs.d




