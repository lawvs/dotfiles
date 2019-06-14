#!/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

apt update && apt upgrade -y
apt install -y git vim build-essential screenfetch
apt install -y curl netcat

# install zsh
apt install -y zsh

chsh -s $(which zsh)

