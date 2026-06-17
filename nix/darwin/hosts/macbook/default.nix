{
  username,
  ...
}:
{
  imports = [
    ../../modules/core.nix
    ../../modules/packages.nix
    ../../modules/shell.nix
    ../../modules/system.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
  };

  system.stateVersion = 6;
}
