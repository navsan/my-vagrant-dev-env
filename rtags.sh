#!/bin/bash

if [ $(which rc | grep -c "not found") -eq 1]; then
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
