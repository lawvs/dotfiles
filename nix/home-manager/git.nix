{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      core = {
        editor = "vim";
        quotepath = false;
      };

      user = {
        name = "lawvs";
        email = "18554747+lawvs@users.noreply.github.com";
      };

      pager.branch = false;

      pull.ff = "on";

      push = {
        default = "simple";
        autoSetupRemote = true;
      };

      rebase = {
        autoStash = true;
        autoSquash = true;
      };
    };
  };
}
