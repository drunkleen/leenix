{
  lib,
  pkgs,
  leenix,
  ...
}:

let
  scripts = import ./scripts { inherit pkgs; };
  waybarEnabled = leenix.desktop.waybar.enable;
in
{
  imports = lib.optionals waybarEnabled [
    ./config.nix
    ./style.nix
  ];

  home.packages = lib.mkIf waybarEnabled [
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
  systemd.user.services.waybar = lib.mkIf waybarEnabled {
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
