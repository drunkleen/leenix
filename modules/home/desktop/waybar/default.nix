{
  lib,
  pkgs,
  variables,
  ...
}:

let
  scripts = import ./scripts { inherit pkgs; };
in
{
  imports = lib.optionals variables.desktop.waybar [
    ./config.nix
    ./style.nix
  ];

  home.packages = lib.mkIf variables.desktop.waybar [
    scripts.weather
    scripts.idleIndicator
    scripts.notificationIndicator
    scripts.screenrecordingIndicator
    pkgs.libnotify
    pkgs.pamixer
    pkgs.nerd-fonts.jetbrains-mono
  ];
}
