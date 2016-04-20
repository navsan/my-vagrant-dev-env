#!/bin/bash

[[ -z "$SRC_DIR" ]] && SRC_DIR=/home/vagrant/src
cd $SRC_DIR
curl -sSf https://static.rust-lang.org/rustup.sh | sh
cargo install racer
