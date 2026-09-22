#!/usr/bin/env bash

set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

link() {
  local src="$1" dest="$2"

  if [[ -e "$dest" && ! -L "$dest" ]]; then
    echo "Skipping $dest: not a symlink, back it up first"
    return
  fi

  ln -sfn "$src" "$dest"
  echo "Linked $dest -> $src"
}

link "$repo_dir/legacy/zshrc" "$HOME/.zshrc"
link "$repo_dir/legacy/gitconfig" "$HOME/.gitconfig"
link "$repo_dir/nix/home-manager/vim/vimrc" "$HOME/.vimrc"
