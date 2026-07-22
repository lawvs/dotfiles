#!/usr/bin/env bash

set -euo pipefail

key_file="$HOME/.ssh/id_ed25519_github"
config_file="$HOME/.ssh/config"

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [[ -e "$key_file" ]]; then
  echo "Using existing key: $key_file"
else
  email="$(git config --global user.email || true)"
  ssh-keygen -t ed25519 -C "$email" -f "$key_file"
fi

chmod 600 "$key_file"

touch "$config_file"
chmod 600 "$config_file"

if grep -qE "^[[:space:]]*Host[[:space:]]+github\\.com([[:space:]]|\$)" "$config_file"; then
  echo "$config_file already contains Host github.com; leaving it unchanged."
else
  cat >>"$config_file" <<EOF

Host github.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_ed25519_github
EOF
fi

cat "$key_file.pub"
echo "-> https://github.com/settings/ssh/new"

read -r -p "Press enter to test your SSH connection."
ssh -T git@github.com
