{
  lib,
  leenix,
  ...
}:

let
  desktopCap = leenix.profiles.desktop.enable;
  hyprlandCap = leenix.desktop.hyprland.enable;
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

  # User identity derives from the typed LEENIX policy (typed leenix.* policy ->
  # config.leenix -> HM specialArg `leenix`), never from raw host variables.
  home.username = leenix.user.username;
  home.homeDirectory = leenix.user.homeDirectory;

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;
}
