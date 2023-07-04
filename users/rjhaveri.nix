{ pkgs, ... }:

{
  homebrew = {
    enable = true;
    brews = [
      "ansible"
      "black"
      "ca-certificates"
      "cmake"
      "flux"
      "git-delta"
      "gnutls"
      "gnupg"
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
      "speedtest"
      "sshuttle"
      "terraform-docs"
      "tfenv"
      "wget"
      "xz"
      "z"
    ];

    casks = [
      "alfred"
      "rectangle"
      "slack"
      "spotify"
    ];
  };

  # The user should already exist, but we need to set this up so Nix knows
  # what our home directory is (https://github.com/LnL7/nix-darwin/issues/423).
  users.users.rjhaveri = {
    home = "/Users/rjhaveri";
    shell = pkgs.zsh;
  };
}
