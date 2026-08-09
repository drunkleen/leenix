{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;

      col = {
        active_border = {
          colors = [
            "rgba(33ccffee)"
            "rgba(00ff99ee)"
          ];
          angle = 45;
        };

        inactive_border = "rgba(595959aa)";
      };

      resize_on_border = false;
      allow_tearing = false;
      layout = "dwindle";
    };

    decoration = {
      rounding = 0;

      shadow = {
        enabled = true;
        range = 2;
        render_power = 3;
        color = "rgba(1a1a1aee)";
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

    group = {
      col = {
        border_active = {
          colors = [
            "rgba(33ccffee)"
            "rgba(00ff99ee)"
          ];
          angle = 45;
        };

        border_inactive = "rgba(595959aa)";

        border_locked_active = {
          colors = [
            "rgba(33ccffee)"
            "rgba(00ff99ee)"
          ];
          angle = 45;
        };

        border_locked_inactive = "rgba(595959aa)";
      };

      groupbar = {
        font_size = 12;
        font_family = "monospace";
        font_weight_active = "ultraheavy";
        font_weight_inactive = "normal";

        indicator_height = 0;
        indicator_gap = 5;
        height = 22;

        gaps_in = 5;
        gaps_out = 0;

        text_color = "rgb(ffffff)";
        text_color_inactive = "rgba(ffffff90)";

        col = {
          active = "rgba(00000040)";
          inactive = "rgba(00000020)";
        };

        gradients = true;
        gradient_rounding = 0;
        gradient_round_only_edges = false;
      };
    };

    animations = {
      enabled = true;
    };

    dwindle = {
      preserve_split = true;
      force_split = 2;
    };

    scrolling = {
      column_width = 0.49;
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

    # Bézier curves
    bezier = [
      "easeOutQuint, 0.23, 1, 0.32, 1"
      "easeInOutCubic, 0.65, 0.05, 0.36, 1"
      "linear, 0, 0, 1, 1"
      "almostLinear, 0.5, 0.5, 0.75, 1"
      "quick, 0.15, 0, 0.1, 1"
    ];

    # Animations
    animation = [
    {
      leaf = "global";
      enabled = true;
      speed = 10;
      curve = "default";
    }

    {
      leaf = "border";
      enabled = true;
      speed = 5.39;
      curve = "easeOutQuint";
    }

    {
      leaf = "windows";
      enabled = true;
      speed = 3.79;
      curve = "easeOutQuint";
    }

    {
      leaf = "windowsIn";
      enabled = true;
      speed = 4.1;
      curve = "easeOutQuint";
      style = "popin 87%";
    }

    {
      leaf = "windowsOut";
      enabled = true;
      speed = 1.49;
      curve = "linear";
      style = "popin 87%";
    }

    {
      leaf = "fadeIn";
      enabled = true;
      speed = 1.73;
      curve = "almostLinear";
    }

    {
      leaf = "fadeOut";
      enabled = true;
      speed = 1.46;
      curve = "almostLinear";
    }

    {
      leaf = "fade";
      enabled = true;
      speed = 3.03;
      curve = "quick";
    }

    {
      leaf = "layers";
      enabled = true;
      speed = 3.81;
      curve = "easeOutQuint";
    }

    {
      leaf = "layersIn";
      enabled = true;
      speed = 4;
      curve = "easeOutQuint";
      style = "fade";
    }

    {
      leaf = "layersOut";
      enabled = true;
      speed = 1.5;
      curve = "linear";
      style = "fade";
    }

    {
      leaf = "fadeLayersIn";
      enabled = true;
      speed = 1.79;
      curve = "almostLinear";
    }

    {
      leaf = "fadeLayersOut";
      enabled = true;
      speed = 1.39;
      curve = "almostLinear";
    }

    {
      leaf = "workspaces";
      enabled = false;
      speed = 0;
      curve = "ease";
    }

    {
      leaf = "specialWorkspace";
      enabled = true;
      speed = 3;
      curve = "easeOutQuint";
      style = "slidevert";
    }
    ];
  };
}
