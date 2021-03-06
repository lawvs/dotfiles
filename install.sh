#!/bin/bash

set -e

SCRIPT_DIR=$(
  cd $(dirname $0)
  pwd
)
cd $SCRIPT_DIR

ln -sf $SCRIPT_DIR/.vimrc ~/.vimrc
echo '[finished] vim'

ln -sf $SCRIPT_DIR/.gitconfig ~/.gitconfig

# zsh
ln -sf $SCRIPT_DIR/.zshrc ~/.zshrc

# install oh-my-zsh
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# zsh plugins
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zdharma/fast-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/sukkaw/zsh-proxy.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-proxy

# theme
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel9k

echo '[finished] zsh'
