#!/bin/bash

set -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

ln -sf $SCRIPT_DIR/.vimrc ~/.vimrc
echo '[finished] vim'

ln -sf $SCRIPT_DIR/.zshrc ~/.zshrc
echo '[finished] zsh'

