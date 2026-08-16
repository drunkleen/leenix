{
  lib,
  variables,
  ...
}:

let
  desktopCap = variables.profiles.desktop or false;
  hyprlandCap = variables.desktop.hyprland or false;
in

{
  imports = [
    ../modules/home/ai
    ../modules/home/cli
    ../modules/home/git
    ../modules/home/nvim
    ../modules/home/programs
    ../modules/home/scripts
    ../modules/home/shell
    ../modules/home/ssh
    ../modules/home/theme
    ../modules/home/ui
  ]
  # Desktop apps/daemons are capability-gated: a base/server host receives no
  # GUI apps, wallpapers, notifications or other desktop-only components.
  ++ lib.optionals desktopCap [
    ../modules/home/apps
    ../modules/home/desktop
    ../modules/home/services
  ]
  # HyprMon and the whole Hyprland module tree are Hyprland-only. A non-Hyprland
  # host must not receive HyprMon (nor the Hyprland config modules).
  ++ lib.optionals hyprlandCap [
    ../modules/home/hyprland
  ];

  home.username = variables.user.username;
  home.homeDirectory = variables.user.homeDirectory;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
