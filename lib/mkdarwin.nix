name: { darwin, nix-homebrew, nixpkgs, nixpkgs-unstable, home-manager, system, user }:

let
  pkgs = import nixpkgs { inherit system; };
  pkgs-unstable = import nixpkgs-unstable { inherit system; };
in


darwin.lib.darwinSystem rec {
  inherit system;
  specialArgs = { inherit pkgs-unstable; };

  modules = [
    ../machines/${name}.nix
    ../users/${user}.nix
    home-manager.darwinModules.home-manager
    {
      system.stateVersion = 5;
      nixpkgs.config.allowUnfree = true;
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit pkgs-unstable; };
      home-manager.users.${user} = import ../users/home-manager.nix;
    }
    nix-homebrew.darwinModules.nix-homebrew
    {
          nix-homebrew = {
            # Install Homebrew under the default prefix
            user = "${user}";
            enable = true;
            enableRosetta = true;
            autoMigrate = true;

            taps = {};
          };
     }

  ];
}
