name: { darwin, nixpkgs, home-manager, system, user }:

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
  ];
}
