{ lib, ... }:

let
  autostart = [
    "uwsm-app -- mako"
    "! leenix-toggle-enabled waybar-off && uwsm-app -- waybar"
    "uwsm-app -- fcitx5 --disable notificationitem"
    "uwsm-app -- swaybg -i ~/.config/leenix/current/background -m fill"
    "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    "leenix-first-run"
    "leenix-powerprofiles-init"
    "uwsm-app -- leenix-hyprland-monitor-watch"
    # Slow app launch fix -- set systemd vars
    "systemctl --user import-environment $(env | cut -d'=' -f 1)"
    "dbus-update-activation-environment --systemd --all"
    # Run post-boot hooks after startup config has loaded
    "sleep 2 && leenix-hook post-boot"
  ];

  execlines = lib.concatMapStringsSep "\n"
    (cmd: "hl.exec_cmd(${builtins.toJSON cmd})")
    autostart;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
    ${execlines}
    end)
  '';
}
