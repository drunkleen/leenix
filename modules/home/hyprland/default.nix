{
  lib,
  pkgs,
  variables,
  ...
}:

{
  home.packages = with pkgs; [
    gnome-calculator
    voxtype
  ];

  imports = [
    ./autostart.nix
    ./env.nix
    ./hyprland.nix
    ./input.nix
    ./looknfeel.nix
    ./monitors.nix
    ./windows.nix

    ./bindings/general.nix
    ./bindings/clipboard.nix
    ./bindings/media.nix
    ./bindings/tiling.nix
    ./bindings/utilities.nix
  ]
  ++ lib.optional variables.desktop.hypridle ./hypridle.nix
  ++ lib.optional variables.desktop.hyprlock ./hyprlock.nix
  ++ lib.optional variables.desktop.hyprsunset ./hyprsunset.nix
  ++ lib.optional (variables.desktop.environment == "hyprland") ./login.nix;
}
