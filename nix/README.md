# nix-darwin

This directory contains the macOS system configuration for this machine.

Current choices:

- upstream Nix
- nix-darwin with flakes
- fish
- starship
- no Home Manager yet
- no Homebrew yet

## Structure

```text
nix/
├── darwin/
│   ├── hosts/
│   │   └── macbook/
│   │       └── default.nix
│   └── modules/
│       ├── core.nix
│       ├── packages.nix
│       ├── shell.nix
│       └── system.nix
└── home-manager/
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
