{
  lib,
  pkgs,
  variables,
  ...
}:

let
  autostart = [
    "hyprctl setcursor ${variables.cursor.theme} ${builtins.toString variables.cursor.size}"
    "uwsm app -t service -- mako"
    "uwsm app -t service -- fcitx5 --disable notificationitem"
    "uwsm app -t service -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "leenix-powerprofiles-init"
    "uwsm app -t service -- leenix-hyprland-monitor-watch"
    # Slow app launch fix -- set systemd vars
    "systemctl --user import-environment $(env | cut -d'=' -f 1)"
    "dbus-update-activation-environment --systemd --all"
    # Run post-boot hooks after startup config has loaded
    "sleep 2 && leenix-hook post-boot"
  ]
  ++ lib.optional variables.desktop.waybar "! leenix-toggle-enabled waybar-off && uwsm app -t service -- waybar";

  execlines = lib.concatMapStringsSep "\n" (cmd: "hl.exec_cmd(${builtins.toJSON cmd})") autostart;
in
{
  home.packages = with pkgs; [
    fcitx5
    polkit_gnome
  ];

  # polkit_gnome ships an XDG autostart .desktop that systemd-xdg-autostart-generator
  # turns into a second polkit agent, racing the explicit line above and failing
  # with "An authentication agent already exists". Shadow it with Hidden=true.
  xdg.configFile."autostart/polkit-gnome-authentication-agent-1.desktop".text = ''
    [Desktop Entry]
    Hidden=true
  '';

  wayland.windowManager.hyprland.extraConfig = ''
    hl.on("hyprland.start", function()
    ${execlines}
    end)
  '';
}
