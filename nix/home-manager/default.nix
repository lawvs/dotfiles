{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./node.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.man.generateCaches = false;

  home.stateVersion = "26.05";
}
