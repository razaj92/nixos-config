{ config, lib, pkgs, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.stateVersion = "23.05";

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------
  home.packages = [
    pkgs.awscli
    pkgs.bat
    pkgs.coreutils-full
    pkgs.docutils
    pkgs.exa
    pkgs.fd
    pkgs.fzf
    pkgs.gdbm
    pkgs.htop
    pkgs.ipcalc
    pkgs.jq
    pkgs.k9s
    pkgs.kops
    pkgs.krew
    pkgs.kubectx
    pkgs.lsd
    pkgs.neovim
    pkgs.ripgrep
    pkgs.socat
    pkgs.tflint
    pkgs.tmux
    pkgs.tree
    pkgs.tree-sitter
    pkgs.vault
    pkgs.watch
    pkgs.yq
    pkgs.zoxide
  ];

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
          "$HOME/Github"
        ];

        exact = [ "$HOME/.envrc" ];
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
