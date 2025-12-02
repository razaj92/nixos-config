{ config, lib, pkgs, pkgs-unstable, ... }:

let
  isDarwin = pkgs.stdenv.isDarwin;
in
{
  home.stateVersion = "23.05";

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------
  home.packages = with pkgs;[
    awscli2
    conftest
    cookiecutter
    coreutils-full
    cargo
    dive
    cilium-cli
    colima
    docker
    docutils
    fd
    fx
    gdbm
    go-task
    helmfile
    htop
    ipcalc
    istioctl
    jq
    jqp
    jwt-cli
    krew
    kubectl
    kubectx
    kubent
    kubetail
    obsidian
    pkgs-unstable.kubectl-klock
    pkgs-unstable.kyverno
    pkgs-unstable.neovim
    pssh
    niv
    ripgrep
    socat
    step-cli
    stern
    tflint
    tilt
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

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionPath = [
    "$HOME/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "$HOME/.krew/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    EDITOR = "nvim";
    PAGER = "less -FirSwX";
    XDG_CONFIG_HOME = "$HOME/.config";
    INFRA_SKIP_VERSION_CHECK = "true";
    KUBECOLOR_OBJ_FRESH="30m";
  };

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    autocd = true;

    history = {
      save = 100000;
      share = true;
      size = 100000;
      expireDuplicatesFirst = true;
      extended = true;
      ignoreAllDups = true;
    };

    historySubstringSearch = {
      enable = true;
    };

    envExtra = ''
      GEOMETRY_RPROMPT=(geometry_git geometry_jobs geometry_echo)
    '';

    initContent = ''
      test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
      iterm2_print_user_vars() {
        iterm2_set_user_var kubecluster $(kubectx -c)
        iterm2_set_user_var kubens $(kubens -c)
        iterm2_set_user_var kube "☸"
      }
      bindkey '^V^V' edit-command-line
      # eng-bootstrap
      export CHEF_LICENSE=accept-silent
      export KITCHEN_LOCAL_YAML=.kitchen.gce.yml
      autoload -Uz compinit && compinit;
      find ~/.chef-shell-init.zsh -mtime +1d -delete > /dev/null 2>&1
      if [ ! -f ~/.chef-shell-init.zsh ]
      then
        cinc shell-init zsh > ~/.chef-shell-init.zsh
      fi
      source ~/.chef-shell-init.zsh
      # others
      compdef kubecolor=kubectl
      # opts
      setopt INC_APPEND_HISTORY
    '';

    shellAliases = {
      vi = "nvim";
      grepnc = "grep -v '^$\|^\s*\#'";
      td = "ultralist";
      kctx = "kubectx";
      kns = "kubens";
      kubectl = "kubecolor";
      lzd = "lazydocker";
      lzg = "lazygit";
      kk = "kubectl get po";
      kky = "ky get po";
      kkk = "kubectl get po -A";
      weather = "curl wttr.in";
      temp = "sudo powermetrics --samplers smc |grep -i \"CPU die temperature\"";
      psk = "ps -ax | fzf | cut -d \" \" -f1 | xargs -o kill";
      gpro = "git pull --rebase origin";
      kgpuse = "kubectl get pods -o custom-columns=\"POD:.metadata.name,CPU_REQUEST:.spec.containers[*].resources.requests.cpu,MEMORY_REQUEST:.spec.containers[*].resources.requests.memory\"";
      kgpzone = "kubectl get pods -o custom-columns=\"NAMESPACE:.metadata.namespace,NAME:.metadata.name,ZONE:.metadata.annotations.topology\.kubernetes\.io/zone\"  | sort -k3 | uniq -c -f2";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
    };

    plugins = [
      {
        name = "geometry";
        src = pkgs.fetchFromGitHub {
          owner = "geometry-zsh";
          repo = "geometry";
          rev = "0f82c567db277024f340b5854a646094d194a31f";
          sha256 = "sha256-FoOY7dkeYC7xQJkX06IDZdduXCfpDxB2aHoSludAMbI=";
        };
      }
    ];

    zsh-abbr = {
      enable = true;
      globalAbbreviations = {
        G = "| grep";
        L = "| less -R";
      };
    };

    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.zsh";
      plugins = [
        "docker"
        "aws"
        "kubectl"
        "git"
        "common-aliases"
        "fzf"
        "fancy-ctrl-z"
        "z"
      ];
    };
  };

  programs.bat = {
    enable = true;
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
      branch.sort = "committerdate";
      color.ui = true;
      column.ui = "auto";
      diff.algorithm = "histogram";
      diff.colorMoved = "plain";
      fetch.all = "true";
      fetch.prune = "true";
      fetch.pruneTags = "true";
      help.autocorrect = "prompt";
      init.defaultBranch = "main";
      pretty.log = "C(240)%h%C(reset) -%C(auto)%d%Creset %s %C(242)(%an %ar)";
      pull.rebase = true;
      push.autoSetupRemote = "true";
      rebase.updateRefs = "true";
      tag.sort = "version:refname";
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
  };

  programs.k9s = {
    enable = true;
  };

  programs.mr = {
    enable = true;
  };
}
