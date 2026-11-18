{ pkgs-unstable, ... }: {

  home.username = "rjhaveri";
  home.homeDirectory = "/home/rjhaveri";

  # Coding agents. Both from unstable: omp is not in the stable channel, and
  # stable claude-code lags far behind upstream. Store binaries can't
  # self-update; bump nixpkgs-unstable instead.
  home.packages = [
    pkgs-unstable.claude-code
    pkgs-unstable.omp
  ];

  # Distinct status symbol so the geometry prompt shows which machine this is.
  programs.zsh.envExtra = ''
    GEOMETRY_STATUS_SYMBOL="◆"
    GEOMETRY_STATUS_SYMBOL_ERROR="◇"
  '';
}
