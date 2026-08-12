{ lib, ... }:

let
  # Convert Nix values to valid Lua table values.
  # We generate the new Hyprland 0.55+ API ourselves instead of letting
  # Home Manager translate the old Hyprlang windowrule syntax.
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

  windowRules = [
    # Suppress maximize events
    {
      match.class = ".*";
      suppress_event = "maximize";
    }

    # Tag all windows for default opacity
    {
      match.class = ".*";
      tag = "+default-opacity";
    }

    # Fix some dragging issues with XWayland
    {
      match = {
        class = "^$";
        title = "^$";
        xwayland = true;
        float = true;
        fullscreen = false;
        pin = false;
      };

      no_focus = true;
    }

    # Bitwarden
    {
      match.class = "^([b|B]itwarden)$";
      no_screen_share = true;
    }
    {
      match.class = "^([b|B]itwarden)$";
      tag = "+floating-window";
    }

    {
      match.class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default";
      no_screen_share = true;
    }
    {
      match.class = "chrome-nngceckbapebfimnlniiiahkandclblb-Default";
      tag = "+floating-window";
    }

    {
      match.class = "firefox-nngceckbapebfimnlniiiahkandclblb-Default";
      no_screen_share = true;
    }
    {
      match.class = "firefox-nngceckbapebfimnlniiiahkandclblb-Default";
      tag = "+floating-window";
    }

    # Browser types
    {
      match.class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)";
      tag = "+chromium-based-browser";
    }
    {
      match.class = "([fF]irefox|zen|librewolf)";
      tag = "+firefox-based-browser";
    }
    {
      match.tag = "chromium-based-browser";
      tag = "-default-opacity";
    }
    {
      match.tag = "firefox-based-browser";
      tag = "-default-opacity";
    }

    # Video apps: remove chromium browser tag so they don't get opacity applied
    {
      match.class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)";
      tag = "-chromium-based-browser";
    }
    {
      match.class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)";
      tag = "-default-opacity";
    }

    # Force chromium-based browsers into a tile to deal with --app bug
    {
      match.tag = "chromium-based-browser";
      tile = true;
    }

    # Only a subtle opacity change, but not for video sites
    {
      match.tag = "chromium-based-browser";
      opacity = "1.0 0.985";
    }
    {
      match.tag = "firefox-based-browser";
      opacity = "1.0 0.985";
    }

    # Hide the screen-sharing notification bar
    {
      match.title = ".*is sharing.*";
      workspace = "special silent";
    }

    # GeForce NOW
    {
      match.class = "GeForceNOW";
      idle_inhibit = "fullscreen";
    }

    # JetBrains focus
    {
      match.class = "^(jetbrains-.*)$";
      no_follow_mouse = true;
    }

    # Float LocalSend and fzf file picker
    {
      match.class = "(Share|localsend)";
      float = true;
    }
    {
      match.class = "(Share|localsend)";
      center = true;
    }
    {
      match.class = "localsend";
      size = [
        1100
        700
      ];
    }

    # Moonlight
    {
      match.class = "com.moonlight_stream.Moonlight";
      fullscreen = true;
      idle_inhibit = "fullscreen";
    }

    # Picture-in-picture overlays
    {
      match.title = "(Picture.?in.?[Pp]icture)";
      tag = "+pip";
    }
    {
      match.tag = "pip";
      tag = "-default-opacity";
    }
    {
      match.tag = "pip";
      float = true;
    }
    {
      match.tag = "pip";
      pin = true;
    }
    {
      match.tag = "pip";
      size = [
        600
        338
      ];
    }
    {
      match.tag = "pip";
      keep_aspect_ratio = true;
    }
    {
      match.tag = "pip";
      border_size = 0;
    }
    {
      match.tag = "pip";
      opacity = "1 1";
    }
    {
      match.tag = "pip";
      move = [
        "(monitor_w-window_w-40)"
        "(monitor_h*0.04)"
      ];
    }

    # QEMU
    {
      match.class = "qemu";
      tag = "-default-opacity";
    }
    {
      match.class = "qemu";
      opacity = "1 1";
    }

    # RetroArch
    {
      match.class = "com.libretro.RetroArch";
      fullscreen = true;
    }
    {
      match.class = "com.libretro.RetroArch";
      tag = "-default-opacity";
    }
    {
      match.class = "com.libretro.RetroArch";
      opacity = "1 1";
    }
    {
      match.class = "com.libretro.RetroArch";
      idle_inhibit = "fullscreen";
    }

    # Float Steam
    {
      match.class = "steam";
      float = true;
    }
    {
      match = {
        class = "steam";
        title = "Steam";
      };
      center = true;
    }
    {
      match.class = "steam.*";
      tag = "-default-opacity";
    }
    {
      match.class = "steam.*";
      opacity = "1 1";
    }
    {
      match = {
        class = "steam";
        title = "Steam";
      };
      size = [
        1100
        700
      ];
    }
    {
      match = {
        class = "steam";
        title = "Friends List";
      };
      size = [
        460
        800
      ];
    }
    {
      match.class = "steam";
      idle_inhibit = "fullscreen";
    }

    # Floating windows
    {
      match.tag = "floating-window";
      float = true;
    }
    {
      match.tag = "floating-window";
      center = true;
    }
    {
      match.tag = "floating-window";
      size = [
        875
        600
      ];
    }

    {
      match.class = "(org.leenix.bluetui|org.leenix.impala|org.leenix.wiremix|org.leenix.btop|org.leenix.terminal|org.leenix.bash|org.codeberg.dnkl.foot|org.gnome.Evince|com.gabm.satty|Leenix|About|TUI.float|imv|mpv)";
      tag = "+floating-window";
    }

    {
      match = {
        class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors)";
        title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)";
      };

      tag = "+floating-window";
    }

    {
      match.class = "org.gnome.Calculator";
      float = true;
    }

    # Fullscreen screensaver
    {
      match.class = "org.leenix.screensaver";
      fullscreen = true;
    }
    {
      match.class = "org.leenix.screensaver";
      float = true;
    }
    {
      match.class = "org.leenix.screensaver";
      animation = "slide";
    }

    # No transparency on media windows
    {
      match.class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv)$";
      tag = "-default-opacity";
    }
    {
      match.class = "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv)$";
      opacity = "1 1";
    }

    # Popped window rounding
    {
      match.tag = "pop";
      rounding = 8;
    }

    # Prevent idle while open
    {
      match.tag = "noidle";
      idle_inhibit = "always";
    }

    # Prevent Telegram from stealing focus on new messages
    {
      match.class = "org.telegram.desktop";
      focus_on_activate = false;
    }

    # Define terminal tag to style them uniformly
    {
      match.class = "(Alacritty|kitty|com.mitchellh.ghostty|foot)";
      tag = "+terminal";
    }
    {
      match.tag = "terminal";
      tag = "-default-opacity";
    }
    {
      match.tag = "terminal";
      opacity = "0.985 0.96";
    }

    # Webcam overlay for screen recording
    {
      match.title = "WebcamOverlay";
      float = true;
    }
    {
      match.title = "WebcamOverlay";
      pin = true;
    }
    {
      match.title = "WebcamOverlay";
      no_initial_focus = true;
    }
    {
      match.title = "WebcamOverlay";
      no_dim = true;
    }
    {
      match.title = "WebcamOverlay";
      move = [
        "(monitor_w-window_w-40)"
        "(monitor_h-window_h-40)"
      ];
    }

    # Apply default opacity after apps have had a chance to opt out
    {
      match.tag = "default-opacity";
      opacity = "0.985 0.96";
    }
  ];

  layerRules = [
    # Remove 1px border around hyprshot screenshots
    {
      match.namespace = "selection";
      no_anim = true;
    }

    # Application-specific animation
    {
      match.namespace = "walker";
      no_anim = true;
    }
  ];

  windowRuleLua =
    lib.concatMapStringsSep "\n"
      (rule: "hl.window_rule(${toLua rule})")
      windowRules;

  layerRuleLua =
    lib.concatMapStringsSep "\n"
      (rule: "hl.layer_rule(${toLua rule})")
      layerRules;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${windowRuleLua}

    ${layerRuleLua}
  '';
}
