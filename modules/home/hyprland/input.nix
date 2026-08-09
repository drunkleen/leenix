{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    input = {
      kb_layout = "us,ir";
      kb_options = "grp:alt_shift_toggle";

      repeat_rate = 40;
      repeat_delay = 250;

      numlock_by_default = true;

      touchpad = {
        clickfinger_behavior = true;
        scroll_factor = 0.4;
      };
    };

    windowrule = [
      "match:class (Alacritty|kitty|foot), scroll_touchpad 1.5"
      "match:class com.mitchellh.ghostty, scroll_touchpad 0.2"
    ];
  };
}
