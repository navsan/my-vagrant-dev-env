#!/bin/bash

if ! which rc > /dev/null ; then
    # Try getting from cache
    RTAGS_DEB=${CACHE_DIR}/rtags.deb
    if [[ -f ${RTAGS_DEB} ]]; then
        dpkg -i ${RTAGS_DEB}
    fi
fi

if ! which rc > /dev/null ; then
    echo "Could not find rtags.deb in cache. Building from source."


	# Install llvm and clang stuff 
	# wget -O - http://llvm.org/apt/llvm-snapshot.gpg.key|sudo apt-key add -
	sudo apt-get install -y clang-3.7 libclang-common-3.7-dev libclang-3.7-dev libclang1-3.7 libllvm3.7 lldb-3.7 llvm-3.7 llvm-3.7-dev llvm-3.7-examples llvm-3.7-runtime clang-modernize-3.7 clang-format-3.7 lldb-3.7-dev

	cd $SRC_DIR
	if [ ! -d rtags ]; then 
	    git clone https://github.com/Andersbakken/rtags.git
		cd rtags
		git submodule init
    	git submodule update
	else 
		cd rtags 
		git pull 
	fi
    cd $SRC_DIR/rtags
    sudo apt-get install -y libncurses5-dev
    mkdir build
    cd build
    cmake ..
    make -j 3
    sudo checkinstall -Dy --pkgname=rtags --install
fi
