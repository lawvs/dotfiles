{
  config,
  inputs,
  lib,
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
      "agent-browser"
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

  system.activationScripts.homebrew.text = lib.mkAfter ''
    sudo -H -u ${lib.escapeShellArg username} /bin/sh -c '
      for browser in "$HOME"/.agent-browser/browsers/chrome-*/"Google Chrome for Testing.app/Contents/MacOS/Google Chrome for Testing"; do
        if [ -x "$browser" ]; then
          exit 0
        fi
      done

      "${config.homebrew.prefix}/bin/agent-browser" install
    '
  '';
}
