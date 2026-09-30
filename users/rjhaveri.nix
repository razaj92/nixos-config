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
    bun
    conftest
    cookiecutter
    coreutils-full
    cargo
    dive
    cilium-cli
    docker
    docutils
    fd
    fx
    gdbm
    github-copilot-cli
    go-task
    helmfile
    htop
    ipcalc
    istioctl
    jq
    jqp
    jwt-cli
    kind
    krew
    kubectl
    kubectx
    kubent
    kubetail
    nerd-fonts.hack
    obsidian
    pkgs-unstable.kubectl-klock
    pkgs-unstable.kyverno
    pkgs-unstable.neovim
    pnpm
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
    yarn-berry
    yq
    zoxide
    (google-cloud-sdk.withExtraComponents ([
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ]))
  ] ++ lib.optionals isDarwin [
    colima
  ];

  # Standalone home-manager leaves fontconfig off by default, so linux needs
  # this for fonts from home.packages to be discoverable. On darwin the fonts
  # target module copies them into ~/Library/Fonts/HomeManager instead.
  fonts.fontconfig.enable = !isDarwin;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.krew/bin"
    "$HOME/go/bin"
    "$HOME/.local/bin"
  ] ++ lib.optionals isDarwin [
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
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
      GEOMETRY_RPROMPT=(geometry_kube geometry_git geometry_jobs geometry_echo)

      # kube segment: context/namespace only, always shown. Context names here
      # reach 70+ chars and zsh drops an RPROMPT that does not fit -- taking the
      # git segment with it -- so keep the distinguishing tail.
      GEOMETRY_KUBE_SEPARATOR=/
      GEOMETRY_KUBE_VERSION=false
      GEOMETRY_KUBE_PIN=true
      GEOMETRY_KUBE_MAX_CONTEXT_LEN=28
    '';

    initContent = lib.concatStringsSep "\n" ([
      ''
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
        # functions
        kpod() {
          local image="$1"
          local name="''${2:-mypod}"
          kubectl run "$name" --image="$image" \
            --overrides='{"spec":{"imagePullSecrets":[{"name":"artifacts"}]}}' \
            --dry-run=client -o yaml
        }

        kdep() {
          local image="$1"
          local name="''${2:-mydep}"
          kubectl create deployment "$name" --image="$image" \
            --dry-run=client -o yaml \
            | yq -y '.spec.template.spec.imagePullSecrets=[{"name":"artifacts"}]'
        }
      ''
    ] ++ lib.optionals isDarwin [
      ''
        test -e "''${HOME}/.iterm2_shell_integration.zsh" && source "''${HOME}/.iterm2_shell_integration.zsh"
        iterm2_print_user_vars() {
          iterm2_set_user_var kubecluster $(kubectx -c)
          iterm2_set_user_var kubens $(kubens -c)
          iterm2_set_user_var kube "☸"
        }
      ''
    ]);

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
      psk = "ps -ax | fzf | cut -d \" \" -f1 | xargs -o kill";
      gpro = "git pull --rebase origin";
      kgpuse = "kubectl get pods -o custom-columns=\"POD:.metadata.name,CPU_REQUEST:.spec.containers[*].resources.requests.cpu,MEMORY_REQUEST:.spec.containers[*].resources.requests.memory\"";
      kgpzone = "kubectl get pods -o custom-columns=\"NAMESPACE:.metadata.namespace,NAME:.metadata.name,ZONE:.metadata.annotations.topology\.kubernetes\.io/zone\"  | sort -k3 | uniq -c -f2";
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
    } // lib.optionalAttrs isDarwin {
      temp = "sudo powermetrics --samplers smc |grep -i \"CPU die temperature\"";
    };

    plugins = [
      {
        name = "geometry";
        src = pkgs.fetchFromGitHub {
          owner = "razaj92";
          repo = "geometry";
          rev = "7cc9bdf99e090460c00dd0e8f85576f0d862ddc9";
          sha256 = "sha256-q8EKXB1i7/5Fp3ZUhdef36/CBoE87WFs9vsv4l3xfF0=";
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
          "${config.home.homeDirectory}/github/"
        ];
      };
    };
  };

  programs.git = {
    enable = true;
    signing = {
      key = "2607C831ABF72900";
    };
    settings = {
      user.name = "Raza Jhaveri";
      user.email = "razajhaveri@googlemail.com";
      alias = {
        cb = "checkout -b";
        bd = "branch -D";
        rho = "reset --hard ORIGIN";
        changes = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %Cblue\\ [%cn]' --abbrev-commit --date=relative";
        lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
        log = "log --pretty=log";
      };
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
      url."git@github.com:fastly/".insteadOf = "https://github.com/fastly/";
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.background = "dark";
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

  #---------------------------------------------------------------------
  # Ghostty
  #
  # Ported from the hand-written ~/.config/ghostty/config (iTerm2 migration).
  # nixpkgs splits the package by platform: ghostty is linux-only (GTK4, built
  # from source), ghostty-bin is darwin-only (the signed upstream .app). Both
  # are 1.3.1. home-manager writes $XDG_CONFIG_HOME/ghostty/config on both.
  #
  # The generator sorts keys alphabetically, so this grouping exists here only.
  #---------------------------------------------------------------------

  programs.ghostty = {
    enable = true;
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;

    settings = {
      font-family = "Hack Nerd Font Mono";
      font-size = 13;
      font-thicken = true;

      window-padding-x = 0;
      window-padding-y = 0;
      window-decoration = true;
      window-save-state = "always";
      scrollbar = "never";

      # Opacities are quoted: nix renders the float 0.9 as 0.900000.
      background-opacity = "0.9";
      background-blur-radius = 30;
      unfocused-split-opacity = "0.8";

      cursor-style = "block";
      cursor-style-blink = false;

      # 256MB per surface, allocated lazily as needed. Ghostty has no unlimited
      # option; oldest lines drop once the limit is hit.
      scrollback-limit = 268435456;

      # Base16 Grayscale Dark, carried over from iTerm2
      foreground = "#d0d0d0";
      background = "#202020";
      cursor-color = "#d0d0d0";
      cursor-text = "#151515";
      selection-foreground = "#d0d0d0";
      selection-background = "#303030";

      palette = [
        "0=#151515"
        "1=#ac4142"
        "2=#7e8d50"
        "3=#e5b567"
        "4=#6c99ba"
        "5=#9e4e85"
        "6=#7dd5cf"
        "7=#d0d0d0"
        "8=#505050"
        "9=#ac4142"
        "10=#7e8d50"
        "11=#e5b566"
        "12=#6c99bb"
        "13=#9e4e85"
        "14=#7dd5cf"
        "15=#f5f5f5"
      ];

      # cmd is an alias for super, so these map to Super on linux.
      keybind = [
        "cmd+d=new_split:right"
        "cmd+shift+d=new_split:down"
        "cmd+w=close_surface"
      ];

      copy-on-select = true;
      clipboard-read = "ask";
      clipboard-write = "allow";
      mouse-hide-while-typing = true;
      quit-after-last-window-closed = true;
      shell-integration-features = "cursor,sudo,title,ssh-env,ssh-terminfo,path";
    } // lib.optionalAttrs isDarwin {
      macos-option-as-alt = false;
      macos-titlebar-style = "native";
      macos-window-shadow = true;
    };
  };
}
