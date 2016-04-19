#!/bin/bash
# Rudimentary script to collect some cached packages/binaries to ease
# setup of new boxes

TODAY=`date +%Y-%m-%d`
CACHE_DIR=/home/vagrant/cache_${DATE}
SRC_DIR=/home/vagrant/src
mkdir -p ${CACHE_DIR}


#------------------------------------------------------------------------
#                     apt packages
#------------------------------------------------------------------------
cd /var/cache/apt/archives
tar -zcvf ${CACHE_DIR}/apt-archives.tar.gz *.deb

#------------------------------------------------------------------------
#                     emacs
#------------------------------------------------------------------------
EMACS_SRC_DIR=${SRC_DIR}/emacs-24.5
if [[ -d ${EMACS_SRC_DIR} ]]; then
    cd ${EMACS_SRC_DIR}
    sudo checkinstall -Dy --pkgname=emacs-24.5
    cp ${EMACS_SRC_DIR}/emacs*.deb ${CACHE_DIR}/emacs-24.5_amd64.deb
fi

#------------------------------------------------------------------------
#                     spacemacs
#------------------------------------------------------------------------
# ELPA packages
SPACEMACS_ELPA_DIR=/home/vagrant/.emacs.d/elpa
if [[ -d ${SPACEMACS_ELPA_DIR }]]; then
    cd ${SPACEMACS_ELPA_DIR}
    tar -zcvf ${CACHE_DIR}/spacmacs_elpa.tar.gz . 
fi

# Git repo
cd ${CACHE_DIR}
rm -rf spacemacs
git clone https://github.com/syl20bnr/spacemacs
mv spacemacs .emacs.d
tar -zcvf spacemacs.tar.gz .emacs.d
rm -rf spacemacs

#------------------------------------------------------------------------
#                     rtags
#------------------------------------------------------------------------
RTAGS_BUILD_DIR=${SRC_DIR}/rtags/build
if [[ -d ${RTAGS_BUILD_DIR} ]]; then
    cd ${RTAGS_BUILD_DIR}
    rm rtags_*.deb
    sudo checkinstall -Dy --pkgname=rtags --install=no
    mv rtags_*.deb ${CACHE_DIR}/rtags.deb
fi

#------------------------------------------------------------------------
#                     vim  TODO
#------------------------------------------------------------------------

