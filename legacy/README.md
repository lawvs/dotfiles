# Legacy

Pre-Nix configuration for machines that have not run `darwin-rebuild switch` yet.

The Nix migration deleted `.zshrc` and moved `.gitconfig` into
[../nix/home-manager/](../nix/home-manager/README.md), which left the symlinks in
`$HOME` dangling on already-bootstrapped machines. These files keep zsh and git
working until the switch happens.

| File | Replaced by |
| --- | --- |
| [zshrc](zshrc) | [../nix/home-manager/fish.nix](../nix/home-manager/fish.nix) |
| [gitconfig](gitconfig) | [../nix/home-manager/git/config](../nix/home-manager/git/config) |

`gitconfig` also carries settings that were never committed: the SSH signing
key and the `gh` credential helpers. Port them into
`../nix/home-manager/git/config` before the first switch, or they are lost.

Per-machine and per-workspace git settings stay out of this repository. They
belong in `~/.gitconfig.local`, which `gitconfig` includes and which is never
tracked:

```ini
[includeIf "gitdir:~/workspaces/<workspace>/"]
	path = ~/workspaces/<workspace>/.gitconfig
```

## Link

```sh
./legacy/link.sh
```

## After the first Nix switch

Home Manager writes `~/.config/git/config` and fish replaces zsh, so remove the
legacy links and this directory:

```sh
rm ~/.gitconfig ~/.zshrc
```

`~/.gitconfig` takes precedence over `~/.config/git/config`, so leaving it in
place silently shadows the Home Manager configuration.
