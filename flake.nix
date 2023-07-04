{
  description = "Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      mkDarwin = import ./lib/mkdarwin.nix;
    in
    {
      darwinConfigurations.fastlybook = mkDarwin "fastlybook" {
        inherit darwin nixpkgs home-manager;
        system = "x86_64-darwin";
        user = "rjhaveri";
      };
    };

}
