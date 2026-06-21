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

    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "none";
    };

    casks = [
      "google-chrome"
      "visual-studio-code"
      "telegram"
      "iina"
      "raycast"
      "stats"
    ];
  };
}
