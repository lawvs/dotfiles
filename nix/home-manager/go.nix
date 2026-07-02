{ pkgs, ... }:
{
  home.packages = with pkgs; [
    go
    gopls
    gotools
    protobuf
  ];
}
