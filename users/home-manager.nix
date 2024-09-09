{ config, lib, pkgs, pkgs-unstable, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
  # infra_pkgs = import (builtins.fetchGit {
  #     # Descriptive name to make the store path easier to identify
  #     name = "infra_0_20";
  #     url = "https://github.com/NixOS/nixpkgs/";
  #     ref = "refs/heads/nixpkgs-unstable";
  #     rev = "3c3b3ab88a34ff8026fc69cb78febb9ec9aedb16";
  # }) { inherit (pkgs) system; };
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
    cookiecutter
    coreutils-full
    cargo
    dive
    cilium-cli
    colima
    docker
    docutils
    eza
    fd
    fluxcd
    fx
    gdbm
    go-task
    helmfile
    htop
    ipcalc
    jq
    jqp
    jwt-cli
    k9s
    kops
    krew
    kubectx
    kubent
    kubetail
    kyverno
    pkgs-unstable.neovim
    pssh
    niv
    ripgrep
    socat
    step-cli
    stern
    tflint
    tmux
    tree
    tree-sitter
    trivy
    vault
    watch
    yamllint
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

  home.sessionPath = [
    "$HOME/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "$HOME/.krew/bin"
    "$HOME/go/bin"
    "$HOME/.chefdk/gem/ruby/2.6.0/bin"
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    INFRA_SKIP_VERSION_CHECK = "true";
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;

    history = {
      save = 100000;
      share = true;
      size = 100000;
      expireDuplicatesFirst = true;
    };

    historySubstringSearch = {
      enable = true;
    };

    envExtra = ''
      GEOMETRY_RPROMPT=(geometry_git geometry_jobs geometry_echo)
    '';

    initExtra = ''
      test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
      bindkey '^V^V' edit-command-line
      # eng-bootstrap
      export CHEF_LICENSE=accept-silent
      export KITCHEN_LOCAL_YAML=.kitchen.gce.yml
      autoload -Uz compinit && compinit; eval "$(chef shell-init zsh)"
    '';

    shellAliases = {
      vi = "nvim";
      grepnc = "grep -v '^$\|^\s*\#'";
      td = "ultralist";
      kctx = "kubectx";
      kns = "kubens";
      lzd = "lazydocker";
      lzg = "lazygit";
      kk = "kubectl get po";
      kky = "ky get po";
      kkk = "kubectl get po -A";
      weather = "curl wttr.in";
      temp = "sudo powermetrics --samplers smc |grep -i \"CPU die temperature\"";
      psk = "ps -ax | fzf | cut -d \" \" -f1 | xargs -o kill";
      gpro = "git pull --rebase origin";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
    };

    plugins = [
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "143b25eb98aa3227af63bd7f04413e1b3e7888ec";
          sha256 = null;
        };
      }
      {
        name = "geometry";
        src = pkgs.fetchFromGitHub {
          owner = "geometry-zsh";
          repo = "geometry";
          rev = "6825dede0fa496ac724aabaf7916c6f1cb6a5292";
          sha256 = null;
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.zsh";
      plugins = [
        "docker aws kubectl git common-aliases fzf fancy-ctrl-z z"
      ];
    };
  };


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
    difftastic = {
      enable = true;
      background = "dark";
    };
    extraConfig = {
      color.ui = true;
      pull.rebase = true;
      pretty.log = "C(240)%h%C(reset) -%C(auto)%d%Creset %s %C(242)(%an %ar)";
      init.defaultBranch = "main";
    };
  };

  programs.go = {
    enable = true;
  };

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = ["--bind=\'ctrl-o:execute-silent(atom{})+abort\'"];
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

}
