{ config, pkgs, ... }: {
  nix.useDaemon = true;

  programs.zsh.enable = true;
  programs.zsh.shellInit = ''
    # Nix
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
    # End Nix
  '';

  environment.shells = with pkgs; [ zsh ];
  environment.systemPackages = with pkgs; [ ];

  networking.hostName = "fastlybook";
  networking.dns = [
    "1.1.1.1"
    "1.0.0.1"
  ];
  networking.knownNetworkServices = [
    "Wi-Fi"
    "Ethernet Adaptor"
  ];
}
