{ vars, ... }:

{
  imports = [
    ../../modules/home/cli
    ../../modules/home/git
    ../../modules/home/zsh
    ../../modules/home/terminal
    ../../modules/home/fzf

    ../../modules/home/themes
    ../../modules/home/hyprland
    ../../modules/home/waybar
    ../../modules/home/walker
  ];

  home.username = vars.username;
  home.homeDirectory = "/home/${vars.username}";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
