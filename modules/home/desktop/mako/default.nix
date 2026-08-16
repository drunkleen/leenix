{
  lib,
  pkgs,
  variables,
  ...
}:

{
  services.mako = {
    enable = variables.desktop.waybar.enable;

    settings = {
      anchor = "top-right";
      background-color = "#0b1113";
      border-color = "#0b1113";
      border-size = 2;
      border-radius = 0;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      group-by = "app-name,summary,body";
      height = 100;
      icons = true;
      layer = "overlay";
      max-icon-size = 32;
      max-visible = 5;
      outer-margin = 20;
      padding = "10,15";
      progress-color = "#4c6a6f";
      text-color = "#d8e3e0";
      width = 420;

      "app-name=Spotify" = {
        invisible = true;
      };

      "mode=do-not-disturb" = {
        invisible = true;
      };

      "mode=do-not-disturb app-name=notify-send" = {
        invisible = false;
      };

      "summary~=\"Learn Keybindings\"" = {
        on-button-left = "exec leenix-notification-dismiss \"Learn Keybindings\"; leenix-menu-keybindings";
      };

      "summary~=\"Screenshot copied & saved\"" = {
        max-icon-size = 80;
        format = "<b>%s</b>\\n%b";
      };

      "summary~=\"Setup Wi-Fi\"" = {
        on-button-left = "exec leenix-notification-dismiss \"Setup Wi-Fi\"; leenix-launch-wifi";
      };

      "urgency=critical" = {
        border-color = "#a55555";
        default-timeout = 0;
        layer = "overlay";
      };

      "urgency=low" = {
        border-color = "#4c6a6f";
        default-timeout = 3000;
      };

      "urgency=normal" = {
        border-color = "#4c6a6f";
      };
    };
  };

  # Canonical systemd ownership for the notification daemon: a real user
  # service bound to the graphical session, started exactly once, restarted on
  # failure. The legacy autostart line (`uwsm app -t service -- mako`) is
  # removed so there is a single owner and mako cannot be missed by scripts that
  # inspect process state.
  systemd.user.services.mako = lib.mkIf variables.desktop.waybar.enable {
    Unit = {
      Description = "Mako notification daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.Notifications";
      ExecStart = "${pkgs.mako}/bin/mako";
      Restart = "on-failure";
      RestartSec = 2;
    };

    Install.WantedBy = [ "graphical-session.target" ];
  };
}
