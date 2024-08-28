{
  description = "Nix config";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-homebrew, homebrew-cask-fonts, darwin, ... }@inputs:
    let
      mkDarwin = import ./lib/mkdarwin.nix;
    in
    {
      darwinConfigurations.fastlybook = mkDarwin "fastlybook" {
        inherit darwin nixpkgs nixpkgs-unstable nix-homebrew homebrew-cask-fonts home-manager;
        system = "aarch64-darwin";
        user = "rjhaveri";
      };
    };

}
