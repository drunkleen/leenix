{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-screensaver";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        procps
        hyprland
        jq
        libnotify
        terminaltexteffects
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix screensaver in the default terminal on the system with the correct font configuration.

        if ! command -v tte &>/dev/null; then
          exit 1
        fi

        # Exit early if screensave is already running

        pgrep -f org.leenix.screensaver && exit 0

        # Allow screensaver to be turned off but also force started

        if leenix-toggle-enabled screensaver-off && [[ "''${1:-}" != "force" ]]; then
          exit 1
        fi

        # Silently quit Walker on overlay

        walker -q

        # Encode a shell string as a Lua string literal. JSON escaping yields a
        # valid Lua string for ASCII input (Hyprland monitor names and the
        # terminal commands below), so monitor names are never interpolated
        # into raw Lua source unescaped.
        lua_str() {
          jq -rn --arg s "$1" '$s|@json'
        }

        focused=$(leenix-hyprland-monitor-focused)
        terminal=$(xdg-terminal-exec --print-id)

        for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
          hyprctl dispatch "hl.dsp.focus({ monitor = $(lua_str "$m") })" >/dev/null

          case $terminal in
            *Alacritty*)
              hyprctl dispatch "hl.dsp.exec_cmd($(lua_str "alacritty --class=org.leenix.screensaver -e leenix-screensaver"))" >/dev/null
              ;;
            *ghostty*)
              hyprctl dispatch "hl.dsp.exec_cmd($(lua_str "ghostty --class=org.leenix.screensaver --font-size=18 -e leenix-screensaver"))" >/dev/null
              ;;
            *foot*)
              hyprctl dispatch "hl.dsp.exec_cmd($(lua_str "foot --app-id=org.leenix.screensaver -e leenix-screensaver"))" >/dev/null
              ;;
            *kitty*)
              hyprctl dispatch "hl.dsp.exec_cmd($(lua_str "kitty --class=org.leenix.screensaver --override font_size=18 --override window_padding_width=0 -e leenix-screensaver"))" >/dev/null
              ;;
            *)
              notify-send -u low "✋  Screensaver only runs in Alacritty, Foot, Ghostty, or Kitty"
              ;;
          esac
        done

        hyprctl dispatch "hl.dsp.focus({ monitor = $(lua_str "$focused") })" >/dev/null
      '';
    })
  ];
}