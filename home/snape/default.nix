{ vars, ... }:

{
  imports = [
    ../../modules/home/cli
    ../../modules/home/git
    ../../modules/home/zsh
    ../../modules/home/terminal
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
