{
  lib,
  pkgs,
  variables,
  ...
}:

let
  autostart = [
    "hyprctl setcursor ${variables.cursor.theme} ${builtins.toString variables.cursor.size}"
    # mako runs as a canonical user service (systemd.user.services.mako,
    # wanted by graphical-session.target) — no autostart line here.
    "uwsm app -t service -- fcitx5 --disable notificationitem"
    "uwsm app -t service -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "leenix-powerprofiles-init"
    # Monitor topology reconciliation runs as a dedicated user systemd service
    # (leenix-monitor-state-watch.service) in the hyprland capability group.
    # Slow app launch fix -- set systemd vars
    "systemctl --user import-environment $(env | cut -d'=' -f 1)"
    "dbus-update-activation-environment --systemd --all"
    # Re-apply the canonical locale to the (possibly persistent) user manager,
    # replacing any stale LC_* from a previous generation.
    "leenix-locale-env"
    # Run post-boot hooks after startup config has loaded
    "sleep 2 && leenix-hook post-boot"
    # Reapply persistent desired runtime states (animations, touchpad, …).
    # Self-gating; Nix stays the source of config truth.
    "command -v leenix-desktop-state-apply >/dev/null && leenix-desktop-state-apply"
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
