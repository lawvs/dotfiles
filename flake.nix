{
  description = "whitewater dotfiles and nix-darwin configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      ...
    }:
    let
      system = "aarch64-darwin";
      username = "whitewater";
      host = "macbook";
    in
    {
      darwinConfigurations."${host}" = nix-darwin.lib.darwinSystem {
        inherit system;

        specialArgs = {
          inherit inputs self username;
        };

        modules = [
          ./nix/darwin/hosts/macbook
        ];
      };

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
    };
}
