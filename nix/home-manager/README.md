# Home Manager

This directory contains user-level configuration managed by Home Manager.

Home Manager is wired into nix-darwin, so `darwin-rebuild switch` applies both
system and user configuration.

Currently managed:

- Claude Code
- Git configuration
- Fish configuration
- Go tooling
- Node.js and pnpm
- Rust tooling
- Starship configuration
- Vim configuration
- VS Code settings

## Claude Code

`claude-code.nix` installs the CLI from `nixpkgs`, so it is upgraded by
`nix flake update` and a switch, not by the CLI's own updater. Home Manager
writes nothing into `~/.claude` unless `programs.claude-code.settings` is set,
so existing settings, commands and plugins are left alone.

The official installer puts `claude` in `~/.local/bin`, which takes precedence
over the Nix profile. Remove it before switching, or that copy keeps winning:

```sh
rm ~/.local/bin/claude
```
