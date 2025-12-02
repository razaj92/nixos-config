{
  description = "Nix config";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # home-manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin
    darwin = {
      url = "git+https://github.com/nix-darwin/nix-darwin?ref=nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-homebrew
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-homebrew, darwin, ... }@inputs:
    let
      mkDarwin = import ./lib/mkdarwin.nix;
    in
    {
      darwinConfigurations.fastlybook = mkDarwin "fastlybook" {
        inherit darwin nixpkgs nixpkgs-unstable nix-homebrew home-manager;
        system = "aarch64-darwin";
        user = "rjhaveri";
      };
    };

}
