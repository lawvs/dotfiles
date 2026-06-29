{ ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./node.nix
    ./rust.nix
    ./starship.nix
    ./vscode.nix
  ];

  programs.home-manager.enable = true;
  programs.man.generateCaches = false;

  home.stateVersion = "26.05";
}
