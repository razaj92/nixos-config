name: { darwin, nix-homebrew, homebrew-cask-fonts, nixpkgs, home-manager, system, user }:

darwin.lib.darwinSystem rec {
  inherit system;

  modules = [
    ../machines/${name}.nix
    ../users/${user}.nix
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
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

            taps = {
                "homebrew/homebrew-cask-fonts" = homebrew-cask-fonts;
            };
          };
     }

  ];
}
