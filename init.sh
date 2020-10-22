#!/bin/bash

# Ported from https://github.com/SukkaW/dotfiles/blob/master/_install/wsl.sh
# Thank for [SukkaW](https://github.com/SukkaW)
# licensed under the [The Unlicense](https://github.com/SukkaW/dotfiles/blob/master/LICENSE)

set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  exit 1
fi

SCRIPT_DIR=$(
  cd $(dirname $0)
  pwd
)
cd $SCRIPT_DIR

install-linux-packages() {
  echo "==========================================================="
  echo "* Install packages"
  echo ""
  echo "-----------------------------------------------------------"
  apt update
  apt install -y git vim build-essential screenfetch
  apt install -y python3-dev python3-pip python3-setuptools
  apt install -y curl netcat
  # sudo vim /etc/proxychains.conf
  apt install -y proxychains
  # install zsh
  apt install -y zsh

}

install-nodejs() {
  install-nvm() {
    echo "-----------------------------------------------------------"
    echo "* Installing NVM..."
    echo "-----------------------------------------------------------"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

    echo "-----------------------------------------------------------"
    echo -n "* NVM Verision: "
    command -v nvm
  }

  install-node() {
    echo "-----------------------------------------------------------"
    echo "* Installing NodeJS 12..."
    echo "-----------------------------------------------------------"

    nvm install 12

    echo "-----------------------------------------------------------"
    echo "* Set NodeJS 12 as default..."
    echo "-----------------------------------------------------------"

    nvm use v12
    # nvm alias default v12

    echo "-----------------------------------------------------------"
    echo -n "* NodeJS Version: "

    node -v
  }

  install-yarn() {
    echo "-----------------------------------------------------------"
    echo "* Installing Yarn..."
    echo "-----------------------------------------------------------"

    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install --no-install-recommends -y yarn

    echo "-----------------------------------------------------------"
    echo -n "* Yarn Version: "

    yarn --version
  }

  echo "==========================================================="
  echo "              Setting up NodeJS Environment"

  install-nvm
  install-node
  install-yarn
}

thefuck() {
  echo "==========================================================="
  echo "                      Install thefuck                      "
  echo "-----------------------------------------------------------"

  sudo pip3 install thefuck
}

upgrade-packages() {
  echo "==========================================================="
  echo "                      Upgrade packages                     "
  echo "-----------------------------------------------------------"

  sudo apt update && sudo apt upgrade -y
  pip install --upgrade pip
  npm i -g npm
}

install-linux-packages
install-nodejs
thefuck
upgrade-packages
