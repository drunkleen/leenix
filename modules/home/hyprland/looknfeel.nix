{ lib, ... }:

let
  toLua =
    value:
    if builtins.isBool value then
      if value then "true" else "false"
    else if builtins.isInt value || builtins.isFloat value then
      builtins.toString value
    else if builtins.isString value then
      builtins.toJSON value
    else if builtins.isList value then
      "{ ${lib.concatMapStringsSep ", " toLua value} }"
    else if builtins.isAttrs value then
      "{ ${
        lib.concatStringsSep ", " (
          lib.mapAttrsToList (
            name: innerValue:
            "${name} = ${toLua innerValue}"
          ) value
        )
      } }"
    else
      throw "Unsupported value while generating Hyprland Lua";

  config = {
    general = {
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;

      col = {
        active_border = {
          colors = [
            "rgba(33b8a8ee)"
            "rgba(59d6c5ee)"
          ];
          angle = 45;
        };

        inactive_border = "rgba(223033aa)";
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
        color = "rgba(020405dd)";
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
            "rgba(33b8a8ee)"
            "rgba(59d6c5ee)"
          ];
          angle = 45;
        };

        border_inactive = "rgba(223033aa)";

        border_locked_active = {
          colors = [
            "rgba(4dba7aee)"
            "rgba(5ccbbbee)"
          ];
          angle = 45;
        };

        border_locked_inactive = "rgba(223033aa)";
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

        text_color = "rgb(d8e3e0)";
        text_color_inactive = "rgba(718688cc)";

        col = {
          active = "rgba(11191ccc)";
          inactive = "rgba(0b1113aa)";
        };

        gradients = true;
        gradient_rounding = 0;
        gradient_round_only_edges = false;
      };
    };

    animations = {
      # LEENIX default: animations ON, owned only by the declarative Nix
      # Hyprland config. (The control-center runtime animations toggle was
      # removed; there is no animations state file anymore.)
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
  };

  curves = [
    {
      name = "easeOutQuint";
      points = [
        [ 0.23 1.0 ]
        [ 0.32 1.0 ]
      ];
    }

    {
      name = "easeInOutCubic";
      points = [
        [ 0.65 0.05 ]
        [ 0.36 1.0 ]
      ];
    }

    {
      name = "linear";
      points = [
        [ 0.0 0.0 ]
        [ 1.0 1.0 ]
      ];
    }

    {
      name = "almostLinear";
      points = [
        [ 0.5 0.5 ]
        [ 0.75 1.0 ]
      ];
    }

    {
      name = "quick";
      points = [
        [ 0.15 0.0 ]
        [ 0.1 1.0 ]
      ];
    }
  ];

animations = [
  {
    leaf = "global";
    enabled = true;
    speed = 10;
    bezier = "default";
  }

  {
    leaf = "border";
    enabled = true;
    speed = 5.39;
    bezier = "easeOutQuint";
  }

  {
    leaf = "windows";
    enabled = true;
    speed = 3.79;
    bezier = "easeOutQuint";
  }

  {
    leaf = "windowsIn";
    enabled = true;
    speed = 4.1;
    bezier = "easeOutQuint";
    style = "popin 87%";
  }

  {
    leaf = "windowsOut";
    enabled = true;
    speed = 1.49;
    bezier = "linear";
    style = "popin 87%";
  }

  {
    leaf = "fadeIn";
    enabled = true;
    speed = 1.73;
    bezier = "almostLinear";
  }

  {
    leaf = "fadeOut";
    enabled = true;
    speed = 1.46;
    bezier = "almostLinear";
  }

  {
    leaf = "fade";
    enabled = true;
    speed = 3.03;
    bezier = "quick";
  }

  {
    leaf = "layers";
    enabled = true;
    speed = 3.81;
    bezier = "easeOutQuint";
  }

  {
    leaf = "layersIn";
    enabled = true;
    speed = 4;
    bezier = "easeOutQuint";
    style = "fade";
  }

  {
    leaf = "layersOut";
    enabled = true;
    speed = 1.5;
    bezier = "linear";
    style = "fade";
  }

  {
    leaf = "fadeLayersIn";
    enabled = true;
    speed = 1.79;
    bezier = "almostLinear";
  }

  {
    leaf = "fadeLayersOut";
    enabled = true;
    speed = 1.39;
    bezier = "almostLinear";
  }

  {
    leaf = "workspaces";
    enabled = false;
  }

  {
    leaf = "specialWorkspace";
    enabled = true;
    speed = 3;
    bezier = "easeOutQuint";
    style = "slidevert";
  }
];

  curveLines =
    lib.concatMapStringsSep "\n"
      (
        curve:
        ''
          hl.curve(${builtins.toJSON curve.name}, {
            type = "bezier",
            points = ${toLua curve.points}
          })
        ''
      )
      curves;

  animationLines =
    lib.concatMapStringsSep "\n"
      (animation: "hl.animation(${toLua animation})")
      animations;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.config(${toLua config})

    ${curveLines}

    ${animationLines}
  '';
}
