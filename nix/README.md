# nix-darwin

This directory contains the macOS system configuration for this machine.

Current choices:

- upstream Nix
- nix-darwin with flakes
- fish
- starship
- Home Manager for user-level git, fish, and starship configuration
- Home Manager for global daily-use Node.js and pnpm
- nix-homebrew with Homebrew casks for GUI apps

## Structure

```text
nix/
├── darwin/
│   ├── hosts/
│   │   └── macbook/
│   │       └── default.nix
│   └── modules/
│       ├── core.nix
│       ├── homebrew.nix
│       ├── packages.nix
│       ├── shell.nix
│       └── system.nix
└── home-manager/
    ├── default.nix
    ├── fish.nix
    ├── git.nix
    ├── node.nix
    ├── starship.nix
    └── README.md
```

## Install Nix

Install upstream Nix first:

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
```

Restart the shell after the installer finishes.

## First Switch

Apply the nix-darwin configuration from the repository root:

```sh
nix --extra-experimental-features "nix-command flakes" build .#darwinConfigurations.macbook.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#macbook
```

If nix-darwin reports unexpected files in `/etc`, move the existing files aside
and retry:

```sh
sudo mv /etc/bashrc /etc/bashrc.before-nix-darwin
sudo mv /etc/zshrc /etc/zshrc.before-nix-darwin
```

## Update

After the first successful switch, update the system from the repository root:

```sh
sudo darwin-rebuild switch --flake .#macbook
```

## Fish

nix-darwin installs fish and registers it in `/etc/shells`. Switch the login
shell once after fish appears there:

```sh
chsh -s /run/current-system/sw/bin/fish
```

Open a new terminal to start fish with starship.

## Home Manager

Home Manager is applied through nix-darwin and manages user-level git, fish,
starship, and global daily-use Node.js tooling.

If activation reports an existing file conflict, move the existing user config
aside and retry. For example:

```sh
mv ~/.config/fish/config.fish ~/.config/fish/config.fish.before-home-manager
```

Home Manager writes Git configuration to `~/.config/git/config`. If
`~/.gitconfig` also exists, Git may read both global config files, so keep only
the file you intend to use.

## Homebrew

Homebrew is installed through nix-homebrew and GUI apps are managed through the
nix-darwin Homebrew module.

Currently managed casks:

- Google Chrome
- Visual Studio Code
- Telegram
- IINA
- Raycast
- Stats
- Codex
- LocalSend

Homebrew cleanup is set to `none`, so activation will not remove manually
installed Homebrew packages.

## Notes

The upstream Nix installer may fail to fetch the legacy `nixpkgs` channel. This
configuration uses flakes, so that channel is not required.

The first `sudo nix ... darwin-rebuild` command may warn that `$HOME` is owned
by the normal user while running as root. After `darwin-rebuild` is installed,
prefer `sudo darwin-rebuild switch --flake ...`.

SSH host keys under `/etc/ssh/ssh_host_*` may be created during system
activation. These identify this Mac to incoming SSH clients and are separate
from user keys under `~/.ssh`.

## References

- [ryan4yin/nix-darwin-kickstarter](https://github.com/ryan4yin/nix-darwin-kickstarter)
- [sn0wm1x/os](https://github.com/sn0wm1x/os)
- [sn0wm1x/ur](https://github.com/sn0wm1x/ur)
- [alissa-tung/dot-darwin](https://github.com/alissa-tung/dot-darwin)
- [unixzii/nixos-config](https://github.com/unixzii/nixos-config)
