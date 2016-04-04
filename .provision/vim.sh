#!/bin/bash

if [ $(vim --version | grep -c "Compiled by vagrant") -eq 0 ]; then
	mkdir -p $SRC_DIR
	cd $SRC_DIR
	wget http://mirrors-usa.go-parts.com/pub/vim/unix/vim-7.4.tar.bz2
	tar jxvf vim-7.4.tar.bz2
	cd $SRC_DIR/vim74
	PY_CONFIG=`echo "import sysconfig as s; print s.get_config_var('LIBPL')" | python`
	./configure --enable-cscope --with-features=huge --enable-pythoninterp --with-python-config-dir=$PY_CONFIG --prefix=/usr
	make -j 4
	sudo checkinstall -Dy --install --pkgname=vim-7.4
	sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 1
	sudo update-alternatives --set editor /usr/bin/vim
	sudo update-alternatives --install /usr/bin/vi vi /usr/bin/vim 1
	sudo update-alternatives --set vi /usr/bin/vim
fi

# Set up Vundle
if [ ! -d "$MYHOME/.vim/bundle/Vundle.vim" ]; then
	mkdir -p $MYHOME/.vim/bundle
	chown -R vagrant $MYHOME/.vim/bundle
	git clone https://github.com/VundleVim/Vundle.vim.git $MYHOME/.vim/bundle/Vundle.vim
fi


cd $SRC_DIR/vim74
if [ ! -d "vim-wasabi-colorscheme" ]; then 
	git clone https://github.com/thomd/vim-wasabi-colorscheme.git 
fi
cd vim-wasabi-colorscheme/
mkdir -p $MYHOME/.vim/colors
cp -v colors/* $MYHOME/.vim/colors

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
