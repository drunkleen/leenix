{
  wayland.windowManager.hyprland.settings.exec-once = [
    "systemctl --user start hyprpolkitagent.service"
    "systemctl --user restart waybar.service"
  ];
}
