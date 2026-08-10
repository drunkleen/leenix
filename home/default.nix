{
  variables,
  ...
}:

{
  imports = [
    ../modules/home
  ];

  home.username = variables.user.username;
  home.homeDirectory = variables.user.homeDirectory;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
