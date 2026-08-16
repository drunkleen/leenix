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
  imports = lib.optionals variables.desktop.waybar.enable [
    ./config.nix
    ./style.nix
  ];

  home.packages = lib.mkIf variables.desktop.waybar.enable [
    scripts.weather
    scripts.idleIndicator
    scripts.notificationIndicator
    scripts.screenrecordingIndicator
    pkgs.libnotify
    pkgs.pamixer
    pkgs.nerd-fonts.jetbrains-mono
  ];

  # Canonical systemd ownership: Waybar is a SUPERVISOR-ONLY user service.
  # It must never auto-start from graphical-session.target, so it has no
  # WantedBy here. Whether it starts is decided exclusively by the
  # persisted-state application (leenix-desktop-state-apply.service), which
  # resolves the user's desired visibility and starts/stops this unit.
  # This prevents a persisted-OFF login flash.
  systemd.user.services.waybar = lib.mkIf variables.desktop.waybar.enable {
    Unit = {
      Description = "Waybar status bar";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
