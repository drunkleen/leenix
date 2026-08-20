{
  lib,
  pkgs,
  leenix,
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
    ./hyprmon.nix
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
  ++ lib.optional leenix.desktop.hypridle.enable ./hypridle.nix
  ++ lib.optional leenix.desktop.hyprlock.enable ./hyprlock.nix
  ++ lib.optional leenix.desktop.hyprsunset.enable ./hyprsunset.nix;
}
