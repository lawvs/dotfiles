# Home Manager

This directory contains user-level configuration managed by Home Manager.

Home Manager is wired into nix-darwin, so `darwin-rebuild switch` applies both
system and user configuration.

Currently managed:

- Git configuration
- Fish configuration
- Node.js and pnpm
- Starship configuration

Good later candidates:

- Editor configuration
