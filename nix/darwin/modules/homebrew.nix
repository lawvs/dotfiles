{
  config,
  inputs,
  username,
  ...
}:
{
  nix-homebrew = {
    enable = true;
    user = username;

    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
    };
  };

  homebrew = {
    enable = true;
    taps = builtins.attrNames config.nix-homebrew.taps;
    global.autoUpdate = false;

    onActivation = {
      autoUpdate = false;
      upgrade = true;
      cleanup = "none";
    };

    brews = [
      "witr"
    ];

    casks = [
      "google-chrome"
      "visual-studio-code"
      "telegram"
      "iina"
      "raycast"
      "stats"
      "codex"
      "localsend"
      "orbstack"
      "tailscale-app"
      "resilio-sync"
    ];
  };
}
