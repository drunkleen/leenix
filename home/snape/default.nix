{ vars, ... }:

{
  imports = [
    ../../modules/home/cli
    ../../modules/home/git
    ../../modules/home/neovim
    ../../modules/home/zsh
    ../../modules/home/terminal
    ../../modules/home/fzf

    ../../modules/home/apps
    ../../modules/home/ai

    ../../modules/home/themes
    ../../modules/home/hyprland
    ../../modules/home/swayosd
    ../../modules/home/waybar
    ../../modules/home/walker
    ../../modules/home/power-actions
    ../../modules/home/tools
  ];

  home = {
    inherit (vars) username;
    homeDirectory = "/home/${vars.username}";
    stateVersion = "26.05";
  };

  programs.home-manager.enable = true;
}
