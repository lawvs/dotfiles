{ ... }:
{
  programs.vscode = {
    enable = true;
    package = null;
  };

  home.file."Library/Application Support/Code/User/settings.json".source = ./vscode/settings.json;
}
