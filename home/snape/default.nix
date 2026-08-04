{ vars, ... }:

{
  imports = [
    ../../modules/home/cli
    ../../modules/home/git
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
