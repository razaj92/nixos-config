name: { nixpkgs, nixpkgs-unstable, home-manager, system, user }:

let
  pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
  pkgs-unstable = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
in

home-manager.lib.homeManagerConfiguration {
  inherit pkgs;
  extraSpecialArgs = { inherit pkgs-unstable; };

  modules = [
    ../machines/${name}/home.nix
    ../users/${user}.nix
  ];
}
