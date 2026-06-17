{ pkgs, ... }:
{
  environment.shells = [
    pkgs.fish
  ];

  programs.fish = {
    enable = true;
    promptInit = ''
      starship init fish | source
    '';

    shellAliases = {
      ll = "ls -la";
      vim = "nvim";
    };
  };
}
