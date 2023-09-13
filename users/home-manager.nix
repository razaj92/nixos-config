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

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    history = {
      save = 100000;
      share = true;
      size = 100000;
    };
    
    historySubstringSearch = {
      enable = true;
    };

    localVariables = {
      PATH = "/opt/homebrew/bin:/opt/homebrew/sbin:$PATH";
    };

    shellAliases = {
      vi = "nvim";
      grepnc = "grep -v '^$\|^\s*\#'";
      td = "ultralist";
      kctx = "kubectx";
      kns = "kubens";
      lzd = "lazydocker";
      docker = "nerdctl";
      lzg = "lazygit";
      kk = "kubectl get po";
      kkk = "kubectl get po -A";
      weather = "curl wttr.in";
      temp = "sudo powermetrics --samplers smc |grep -i \"CPU die temperature\"";
      psk = "ps -ax | fzf | cut -d \" \" -f1 | xargs -o kill";
      gpro = "git pull --rebase origin";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      ls = "lsd";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
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
        "docker aws git common-aliases fzf fancy-ctrl-z"
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

  programs.fzf = {
    enable = true;
    defaultCommand = "fd --type f";
    defaultOptions = ["--bind=\'ctrl-o:execute-silent(atom{})+abort\'"];
  };



}
