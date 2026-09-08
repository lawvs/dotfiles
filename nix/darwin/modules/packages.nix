{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    fd
    fish
    git
    git-lfs
    gh
    jq
    neovim
    nixfmt
    ripgrep
    tree
    uv
    vim
    wget
  ];
}
