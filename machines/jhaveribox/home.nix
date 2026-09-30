{ pkgs, ... }: {

  home.username = "rjhaveri";
  home.homeDirectory = "/home/rjhaveri";

  home.packages = with pkgs; [
    kubernetes-helm
    terraform
  ];

  home.sessionPath = [
    "$HOME/.npm-global/bin"
  ];

  # Distinct status symbol so the geometry prompt shows which machine this is.
  programs.zsh.envExtra = ''
    GEOMETRY_STATUS_SYMBOL="⭓"
    GEOMETRY_STATUS_SYMBOL_ERROR="⭔"
  '';
}
