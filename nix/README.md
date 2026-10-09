# nix-darwin

macOS configuration using nix-darwin, Home Manager, and nix-homebrew.
Run the commands below from the repository root.

## Structure

- [darwin/hosts/macbook/](darwin/hosts/macbook/): machine configuration
- [darwin/modules/](darwin/modules/): system settings, packages, fonts, and Homebrew
- [home-manager/](home-manager/README.md): user configuration and development tools

## Install Nix

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
```

Restart the shell after the installer finishes.

## First Switch

```sh
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.macbook.system
sudo ./result/sw/bin/darwin-rebuild switch --flake 'path:.#macbook'
```

## Update

Update all dependencies and apply:

```sh
nix flake update
sudo darwin-rebuild switch --flake 'path:.#macbook'
```

For Homebrew-only dependency updates (including Codex), replace the first command
with:

```sh
nix flake update nix-homebrew homebrew-core homebrew-cask
```

Keep these three inputs in sync for compatible package definitions. After
configuration-only edits, run just the switch command. Review and commit
`flake.lock` after dependency updates.

The switch also upgrades declared Homebrew packages; no separate `brew upgrade`
is needed. Restart Codex sessions after upgrading the CLI.

## Fish

After the first switch, set fish as the login shell once:

```sh
chsh -s /run/current-system/sw/bin/fish
```

Open a new terminal to start fish with starship.

## Homebrew

Declare apps and CLI tools in [homebrew.nix](darwin/modules/homebrew.nix).
Homebrew and its taps are pinned in `flake.lock`, so Homebrew auto-update is
disabled. Activation leaves manually installed, undeclared packages in place.

## Troubleshooting

If activation reports conflicting files, back up only the reported files and
retry. Examples:

```sh
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
mv ~/.config/fish/config.fish ~/.config/fish/config.fish.before-home-manager
```

- `path:.` avoids Git repository ownership errors when switching as root.
- A failed legacy `nixpkgs` channel download does not block this flake-based setup.
- Home Manager uses `~/.config/git/config`; check for duplicate settings in `~/.gitconfig`.
- Select installed fonts in your terminal's own preferences.
