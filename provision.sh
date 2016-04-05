#!/bin/bash
set -e 
set -x 

MYHOME=/home/vagrant
SRC_DIR=$MYHOME/src
PROVISION_DIR=$SRC_DIR/my-vagrant-dev-env

sudo apt-get update -y

# Install development prerequisites
source $PROVISION_DIR/dev-prereq.sh

# Download dotfiles 
source $PROVISION_DIR/dotfiles.sh

# Install zsh
source $PROVISION_DIR/zsh.sh

# Install tmux
source $PROVISION_DIR/tmux.sh

# Install vim from source
source $PROVISION_DIR/vim.sh

# Installing rtags
source $PROVISION_DIR/rtags.sh

# Install and configure spacemacs
source $PROVISION_DIR/spacemacs.sh

# Clean up
sudo apt-get autoremove -y

