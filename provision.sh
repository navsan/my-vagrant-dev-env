#!/bin/bash
set -e 
set -x 

MYHOME=/home/vagrant
SRC_DIR=$MYHOME/src
PROVISION_DIR=$SRC_DIR/my-vagrant-dev-env
CACHE_DIR=$SRC_DIR/cache

sudo apt-get update -y

# Restore cache
source $PROVISION_DIR/restore-cache.sh

# Install development prerequisites
source $PROVISION_DIR/dev-prereq.sh

# Download dotfiles 
source $PROVISION_DIR/dotfiles.sh

# Install and configure spacemacs
source $PROVISION_DIR/spacemacs.sh

# Install zsh
source $PROVISION_DIR/zsh.sh

# Install tmux
source $PROVISION_DIR/tmux.sh

# Installing rtags
source $PROVISION_DIR/rtags.sh

# Install vim from source
source $PROVISION_DIR/vim.sh

# Clean up
sudo apt-get autoremove -y

