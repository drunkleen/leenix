{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.leenix.desktop.hyprland.enable {
    systemd.packages = [
      pkgs.swayosd
    ];

    systemd.services.swayosd-libinput-backend.wantedBy = [
      "graphical.target"
    ];

    services.dbus.packages = [
      pkgs.swayosd
    ];
  };
}
