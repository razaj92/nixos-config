{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "adr-tools"
      "ansible"
      "black"
      "ca-certificates"
      "cmake"
      "dagger"
      "findutils"
      "gnupg"
      "gnutls"
      "helm"
      "jsonlint"
      "linkerd"
      "lua"
      "mackup"
      "mkdocs"
      "mtr"
      "nmap"
      "packer"
      "pygments"
      "speedtest-cli"
      "sshuttle"
      "terraform-docs"
      "tfenv"
      "wget"
      "xz"
      "yh"
      "z"
    ];

    casks = [
       "1password"
       "alfred"
       "brave-browser"
       "dropbox"
       "font-hack-nerd-font"
       "iterm2"
       "keybase"
       "maccy"
       "numi"
       "rectangle"
       "spotify"
       "wireshark"
    ];

    masApps = {
      "Lightshot Screenshot" = 526298438;
      "Tailscale" = 1475387142;
      "Tickbar" = 1666870677;
      "WhatsApp Desktop" = 1147396723;
      "Wireguard" = 1451685025;
    };
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.rjhaveri = {
    home = "/Users/rjhaveri";
    shell = pkgs.zsh;
  };
}
