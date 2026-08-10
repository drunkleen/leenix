{
  lib,
  pkgs,
  variables,
  ...
}:

let
  autostart = [
    "uwsm-app -- mako"
    "uwsm-app -- fcitx5 --disable notificationitem"
    "uwsm-app -- swaybg -i ~/.config/leenix/current/background -m fill"
    "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "leenix-powerprofiles-init"
    "uwsm-app -- leenix-hyprland-monitor-watch"
    # Slow app launch fix -- set systemd vars
    "systemctl --user import-environment $(env | cut -d'=' -f 1)"
    "dbus-update-activation-environment --systemd --all"
    # Run post-boot hooks after startup config has loaded
    "sleep 2 && leenix-hook post-boot"
  ]
  ++ lib.optional variables.desktop.waybar "! leenix-toggle-enabled waybar-off && uwsm-app -- waybar";

  execlines = lib.concatMapStringsSep "\n" (cmd: "hl.exec_cmd(${builtins.toJSON cmd})") autostart;
in
{
  home.packages =
    with pkgs;
    [
      fcitx5
      polkit_gnome
      swaybg
    ]
    ++ lib.optional variables.desktop.waybar waybar;

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
    ${execlines}
    end)
  '';
}
