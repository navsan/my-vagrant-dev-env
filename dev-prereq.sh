#!/bin/bash

# Repo for latest LLVM/Clang
sudo apt-get install -y python-software-properties
sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
sudo add-apt-repository -y 'deb http://llvm.org/apt/trusty/ llvm-toolchain-trusty-3.7 main'


# Repo for latest git - security reasons
sudo apt-add-repository ppa:git-core/ppa

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


# Install other useful tools
sudo apt-get install -y silversearcher-ag ack-grep htop 
sudo dpkg-divert --local --divert /usr/bin/ack --rename --add /usr/bin/ack-grep
