{ ... }: {
  home.username = "rjhaveri";
  home.homeDirectory = "/Users/rjhaveri";

  # kubecolor comes from homebrew here (see system.nix); jhaveribox doesn't
  # install it, so this alias stays machine-local rather than shared.
  programs.zsh.shellAliases = {
    kubectl = "kubecolor";
  };
}
