{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustup

    cargo-deny
    cargo-edit
    cargo-expand
    cargo-nextest
    cargo-watch
    bacon
  ];
}
