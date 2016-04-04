#!/bin/bash
set -e 
set -x 

PROVISION_DIR=/vagrant/.provision
MYHOME=/home/vagrant
SRC_DIR=$MYHOME/src

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
source spacemacs.sh

# Clean up
sudo apt-get autoremove -y

