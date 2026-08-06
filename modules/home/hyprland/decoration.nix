let
  palette = import ../../../lib/leenium.nix;
in
{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      layout = "dwindle";

      resize_on_border = false;
      allow_tearing = false;

      "col.active_border" =
        "${palette.rgba palette.accent.teal "ee"} ${palette.rgba palette.accent.cyan "ee"} 45deg";
      "col.inactive_border" = palette.rgba palette.neutral.activeBorder "aa";
    };

    decoration = {
      rounding = 0;

      shadow = {
        enabled = true;
        range = 2;
        render_power = 3;
        color = palette.rgba palette.neutral.baseBlack "ee";
      };

      blur = {
        enabled = true;
        size = 2;
        passes = 2;
        special = true;
        brightness = 0.60;
        contrast = 0.75;
      };
    };

    dwindle = {
      preserve_split = true;
      force_split = 2;
    };

    master = {
      new_status = "master";
    };

    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      disable_scale_notification = true;
      focus_on_activate = true;
      anr_missed_pings = 3;
      on_focus_under_fullscreen = 1;
    };

    cursor = {
      hide_on_key_press = true;
      warp_on_change_workspace = 1;
    };

    binds = {
      hide_special_on_workspace_change = true;
    };
  };
}
