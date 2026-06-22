{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    maple-mono.NF-CN
    noto-fonts-cjk-sans
  ];
}
