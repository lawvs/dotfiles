{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./starship.nix
  ];

  programs.home-manager.enable = true;
  programs.man.generateCaches = false;

  home.stateVersion = "26.05";
}
