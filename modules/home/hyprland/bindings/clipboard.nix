{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "SUPER, C, Universal copy, sendshortcut, CTRL, Insert, activewindow"
      "SUPER, V, Universal paste, sendshortcut, SHIFT, Insert, activewindow"
      "SUPER, X, Universal cut, sendshortcut, CTRL, X, activewindow"
      "SUPER CTRL, V, Clipboard manager, exec, leenix-launch-walker -m clipboard"
    ];
  };
}
