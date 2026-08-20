{
  lib,
  pkgs,
  leenix,
  ...
}:

let
  # The ASUS firmware handles the physical keyboard-backlight Fn keys directly
  # (no evdev key event, no udev uevent), so LEENIX must observe the sysfs
  # brightness value and render the segmented OSD on change. Polling is the
  # only event source available for this hardware.
  leenix-kbd-backlight-watch = pkgs.writeShellApplication {
    name = "leenix-kbd-backlight-watch";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      #!/bin/bash

      device=""
      for candidate in /sys/class/leds/*kbd_backlight*; do
        if [[ -e $candidate ]]; then
          device="$(basename "$candidate")"
          break
        fi
      done

      if [[ -z $device ]]; then
        echo "No keyboard backlight device found" >&2
        exit 1
      fi

      sys_dir="/sys/class/leds/$device"
      last="$(cat "$sys_dir/brightness" 2>/dev/null || echo 0)"

      while true; do
        sleep 0.25
        cur="$(cat "$sys_dir/brightness" 2>/dev/null || echo 0)"
        if [[ "$cur" != "$last" ]]; then
          last="$cur"
          max="$(cat "$sys_dir/max_brightness" 2>/dev/null || echo 1)"
          leenix-swayosd-kbd-brightness "$cur" "$max"
        fi
      done
    '';
  };
in
{
  config = lib.mkIf leenix.desktop.hyprland.enable {
    home.packages = [
      pkgs.swayosd
      leenix-kbd-backlight-watch
    ];

    xdg.configFile."swayosd/config.toml".text = ''
      [server]
      show_percentage = true
      max_volume = 100
      style = "~/.config/swayosd/style.css"
    '';

    xdg.configFile."swayosd/style.css".text = ''
      @define-color background-color #11191c;
      @define-color border-color #223033;
      @define-color label #d8e3e0;
      @define-color image #d8e3e0;
      @define-color progress #33b8a8;
      @define-color edge-light #59d6c5;

      window:not(:backdrop),
      window:backdrop {
          border: none;
          border-width: 0;
          background-color: transparent;
          box-shadow: none;
          padding: 12px;
      }

      window:not(:backdrop) #container,
      window:backdrop #container {
          border: 2px solid alpha(@border-color, 0.92);
          background-color: alpha(@background-color, 0.95);
          padding: 12px 16px;
          background-clip: padding-box;
      }

      image,
      label {
          color: @label;
      }

      progressbar {
          min-height: 8px;
      }

      progressbar trough {
          background: alpha(@border-color, 0.24);
          box-shadow: inset 0 1px rgba(216, 227, 224, 0.03);
      }

      progressbar progress {
          background: linear-gradient(90deg, @progress, @edge-light);
          box-shadow: 0 0 10px rgba(51, 184, 168, 0.18);
      }

      window {
        border-radius: 0;
        opacity: 0.97;
        border: 2px solid @border-color;
        background-color: @background-color;
      }

      label {
        font-family: 'JetBrainsMono Nerd Font';
        font-size: 11pt;
        color: @label;
      }

      image {
        color: @image;
      }

      progressbar {
        border-radius: 0;
      }

      progress {
        background-color: @progress;
      }

      window#osd progress {
        margin: 0;
      }

      segmentedprogress {
        min-height: 8px;
      }

      segmentedprogress segment {
        min-height: inherit;
        border-radius: 0;
        background: alpha(@border-color, 0.24);
        margin-left: 4px;
      }

      segmentedprogress segment:first-child {
        margin-left: 0;
      }

      segmentedprogress segment.active {
        background: linear-gradient(90deg, @progress, @edge-light);
      }
    '';

    # The swayosd OSD resolves icons through the GTK icon theme. The default
    # theme name is "Adwaita", which is not installed on LEENIX. Provide a
    # minimal Adwaita theme (inheriting hicolor) with an indexed symbolic/status
    # directory so the keyboard-brightness and LEENIUM touchpad OSD icons used
    # by the OSD actually resolve. Icons must live in the indexed directory;
    # installing them elsewhere (e.g. hicolor without an index) silently fails.
    xdg.dataFile."icons/Adwaita/index.theme".text = ''
      [Icon Theme]
      Name=Adwaita
      Comment=LEENIX Adwaita icon theme (minimal)
      Inherits=hicolor
      Directories=symbolic/status

      [symbolic/status]
      Size=16
      MinSize=8
      MaxSize=512
      Type=Scalable
    '';

    xdg.dataFile."icons/Adwaita/symbolic/status/keyboard-brightness-symbolic.svg".source =
      ./files/keyboard-brightness-symbolic.svg;

    xdg.dataFile."icons/Adwaita/symbolic/status/leenix-touchpad-on-symbolic.svg".source =
      ./files/leenix-touchpad-on-symbolic.svg;

    xdg.dataFile."icons/Adwaita/symbolic/status/leenix-touchpad-off-symbolic.svg".source =
      ./files/leenix-touchpad-off-symbolic.svg;

    xdg.dataFile."icons/Adwaita/symbolic/status/leenix-touchscreen-on-symbolic.svg".source =
      ./files/leenix-touchscreen-on-symbolic.svg;

    xdg.dataFile."icons/Adwaita/symbolic/status/leenix-touchscreen-off-symbolic.svg".source =
      ./files/leenix-touchscreen-off-symbolic.svg;

    systemd.user.services.swayosd-server = {
      Unit = {
        Description = "SwayOSD daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "dbus";
        BusName = "org.erikreider.swayosd-server";
        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };

    systemd.user.services.leenix-kbd-backlight-watch = {
      Unit = {
        Description = "Keyboard backlight OSD watcher";
        PartOf = [ "graphical-session.target" ];
        After = [
          "graphical-session.target"
          "swayosd-server.service"
        ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${leenix-kbd-backlight-watch}/bin/leenix-kbd-backlight-watch";
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
