{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us";

      follow_mouse = 1;
      sensitivity = 0;

      repeat_delay = 250;
      repeat_rate = 35;

      accel_profile = "flat";

      touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        disable_while_typing = true;
        clickfinger_behavior = true;
      };
    };

    gesture = [
      "3, horizontal, workspace"
    ];

    gestures = {
      workspace_swipe_invert = false;
      workspace_swipe_forever = true;
    };
  };
}
