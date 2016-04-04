#!/bin/bash
set -e 
set -x 

PROVISION_DIR=/vagrant/.provision
MYHOME=/home/vagrant
SRC_DIR=$MYHOME/src
sudo apt-get update -y

# Install development prerequisites
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
sudo add-apt-repository -y 'deb http://llvm.org/apt/jessie/ llvm-toolchain-jessie-3.7 main'
sudo apt-get update
sudo apt-get install -y	\
	autotools-dev autoconf build-essential \
	checkinstall clang-3.7 cmake cscope\
	gcc-4.9 g++-4.9 gdb \
	git python python-dev
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 20
sudo update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20
sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-3.7 20
sudo update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-3.7 20

# Download dotfiles 
cd $SRC_DIR
DOTFILES=$MYHOME/dotfiles
if [ ! -d $DOTFILES ]; then
	git clone https://navsan@bitbucket.org/navsan/dotfiles.git 
  ln -sf $PROVISION_DIR/dotfiles $DOTFILES
fi

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
if [ ! -f $MYHOME/.tmux.conf ]; then
    sudo apt-get install -y tmux
    ln -sf $DOTFILES/.tmux.conf $MYHOME/.tmux.conf 
    echo "alias tmux=\"tmux -2\"" >> $MYHOME/.myrc  # 256 color support
fi

# Install vim from source
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

# Install other useful tools
sudo apt-get install -y silversearcher-ag ack-grep htop 
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep

# Upgrade to a newer version of git (security reasons)
sudo apt-add-repository ppa:git-core/ppa
sudo apt-get update
sudo apt-get install git

# Installing rtags
if [ $(which rc | grep -c "rc") -eq 0]; then
  cd $SRC_DIR
  git clone https://github.com/Andersbakken/rtags.git
  cd rtags
  git submodule init
  git submodule update
  sudo apt-get install -y libncurses5-dev
  mkdir build
  cd build
  cmake ..
  make -j 3
  make install
fi

# Installing and configuring spacemacs
if [ $(emacs --version | grep -c "GNU Emacs 24.5") -eq 0 ]; then
	  rm -rf $MYHOME/.emacs.d
	  git clone https://github.com/syl20bnr/spacemacs $MYHOME/.emacs.d
	  #DEBIAN_FRONTEND=noninteractive sudo apt-get build-dep -y emacs24		
	  cd $SRC_DIR/
	  wget https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
	  tar zxvf emacs-24.5.tar.gz
	  cd emacs-24.5
	  ./configure
	  make -j 4
	  sudo checkinstall -Dy --install --pkgname=emacs-24.5

    ln -sf $DOTFILES/spacemacs/.spacemacs $MYHOME/.spacemacs
    rm -rf $MYHOME/.emacs.d/private
    ln -sf $DOTFILES/spacemacs/private $MYHOME/.emacs.d/private
fi



# Clean up
sudo apt-get autoremove -y



