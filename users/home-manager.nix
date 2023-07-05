{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.stateVersion = "23.05";

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------
  home.packages = with pkgs;[
    awscli
    bat
    conftest
    coreutils-full
    dive
    docutils
    exa
    fd
    gdbm
    go-task
    htop
    ipcalc
    jq
    jqp
    k9s
    kops
    krew
    kubectx
    kubent
    kubetail
    lsd
    neovim
    niv
    ripgrep
    socat
    step-cli
    stern
    tflint
    tmux
    tree
    tree-sitter
    vault
    watch
    yq
    zoxide
    (google-cloud-sdk.withExtraComponents ([
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
  ];

  # home.file = {
  #   neovim.source = config.lib.file.mkOutOfStoreSymlink /Users/rjhaveri/.nix-profile/bin/nvim;
  #   neovim.target = "/usr/local/bin/vi";
  # };


  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.direnv = {
    enable = true;

    config = {
      whitelist = {
        prefix = [
          "/Users/rjhaveri/Github/"
        ];
      };
    };
  };

  programs.git = {
    enable = true;
    userName = "Raza Jhaveri";
    userEmail = "razajhaveri@googlemail.com";
    signing = {
      key = "2607C831ABF72900";
    };
    aliases = {
      cb = "checkout -b";
      bd = "branch -D";
      rho = "reset --hard ORIGIN";
      changes = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %Cblue\\ [%cn]' --abbrev-commit --date=relative";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      log = "log --pretty=log";
    };
    extraConfig = {
      core.pager = "delta";
      color.ui = true;
      pull.rebase = true;
      pretty.log = "C(240)%h%C(reset) -%C(auto)%d%Creset %s %C(242)(%an %ar)";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
  };
}
