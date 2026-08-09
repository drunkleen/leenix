{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    # env = [
    #   "GDK_SCALE,2"
    # ];

    monitor = [
      {
        output = "eDP-1";
        mode = "2560x1440@165";
        position = "auto";
        scale = 1.6;
      }

      {
        output = "HDMI-A-1";
        mode = "3440x1440@100";
        position = "auto";
        scale = 1.6;
      }
    ];
  };
}
