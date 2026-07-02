{
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -la";
      vim = "nvim";
    };

    shellAbbrs = {
      g = "git";
      ga = "git add";
      gb = "git branch";
      gc = "git commit";
      gco = "git checkout";
      gl = "git pull";
      gp = "git push";
      gst = "git status";
      gsw = "git switch";
    };
  };
}
