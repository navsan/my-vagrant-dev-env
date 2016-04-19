#!/bin/bash

if [ -f $MYHOME/.emacs.d/.spacemacs ]; then
    return
fi

# Install emacs version 24+ first
if [ $(emacs --version | grep -c "GNU Emacs 24.5") -eq 0 ]; then
    # Try to get it from cache first
    EMACS_DEB=${CACHE_DIR}/emacs-24.5_amd64.deb
    if [[ -f ${EMACS_DEB} ]]; then
        dpkg -i ${EMACS_DEB}
    fi

    # Otherwise, build from source
    cd $SRC_DIR/
    wget https://ftp.gnu.org/gnu/emacs/emacs-24.5.tar.gz
    tar zxvf emacs-24.5.tar.gz
    cd emacs-24.5
    ./configure
    make -j 4
    sudo checkinstall -Dy --install --pkgname=emacs-24.5
fi
	
# Now install spacemacs
EMACS_DIR=$MYHOME/.emacs.d
rm -rf ${EMACS_DIR}
# Try to get it from cache first
SPACEMACS_TAR=${CACHE_DIR}/spacemacs.tar.gz
if [[ -f ${SPACEMACS_TAR}]]; then
    cd ${MYHOME}
    tar -zxvf ${SPACEMACS_TAR}
    if [[ ! -d ${EMACS_DIR} ]]; then
        echo "Some error occurred when getting spacemacs from cache."
        echo "Continuing with build from sourceinstead."
    fi
fi
if [[ ! -d ${EMACS_DIR} ]]; then  #build from cache failed
    git clone https://github.com/syl20bnr/spacemacs ${EMACS_DIR}
fi

# Try to restore packages from cache
SPACEMACS_ELPA=${CACHE_DIR}/spacemacs_elpa.tar.gz
if [[ -f $SPACEMACS_ELPA ]]; then
    mkdir -p ${EMACS_DIR}/elpa
    cd ${EMACS_DIR}/elpa
    tar -zxvf ${SPACEMACS_ELPA}
fi

# Link in dot files
ln -sf $DOTFILES/spacemacs/.spacemacs $MYHOME/.spacemacs
rm -rf $MYHOME/.emacs.d/private
ln -sf $DOTFILES/spacemacs/private $MYHOME/.emacs.d/private
chown -R vagrant:vagrant $MYHOME/.emacs.d 


