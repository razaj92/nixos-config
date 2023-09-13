{
  description = "Nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-cask-fonts = {
      url = "github:homebrew/homebrew-cask-fonts";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, home-manager, nix-homebrew, homebrew-cask-fonts, darwin, ... }@inputs:
    let
      mkDarwin = import ./lib/mkdarwin.nix;
    in
    {
      darwinConfigurations.fastlybook = mkDarwin "fastlybook" {
        inherit darwin nixpkgs nix-homebrew homebrew-cask-fonts home-manager;
        system = "aarch64-darwin";
        user = "rjhaveri";
      };
    };

}
