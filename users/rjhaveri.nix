{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "ansible"
      "black"
      "ca-certificates"
      "cmake"
      "findutils"
      "flux"
      "git-delta"
      "gnupg"
      "gnutls"
      "helm"
      "jsonlint"
      "kubernetes-cli"
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
      "z"
    ];

    casks = [
       "dropbox"
       "alfred"
       "iterm2"
       "rectangle"
       "brave-browser"
       "1password"
       "font-hack-nerd-font"
       "spotify"
    ];

    masApps = {
      "Wireguard" = 1451685025;
      "Tailscale" = 1475387142;
      "Lightshot Screenshot" = 526298438;
      "WhatsApp Desktop" = 1147396723;
      "Tickbar" = 1666870677;
    };
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.rjhaveri = {
    home = "/Users/rjhaveri";
    shell = pkgs.zsh;
  };
}
