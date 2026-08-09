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

        if leenix-toggle-enabled screensaver-off && [[ $1 != "force" ]]; then
          exit 1
        fi

        # Silently quit Walker on overlay

        walker -q

        focused=$(leenix-hyprland-monitor-focused)
        terminal=$(xdg-terminal-exec --print-id)

        for m in $(hyprctl monitors -j | jq -r '.[] | .name'); do
          hyprctl dispatch focusmonitor $m

          case $terminal in
            *Alacritty*)
              hyprctl dispatch exec -- \
                alacritty --class=org.leenix.screensaver \
                --config-file ~/.local/share/leenix/default/alacritty/screensaver.toml \
                -e leenix-screensaver
              ;;
            *ghostty*)
              hyprctl dispatch exec -- \
                ghostty --class=org.leenix.screensaver \
                --config-file=~/.local/share/leenix/default/ghostty/screensaver \
                --font-size=18 \
                -e leenix-screensaver
              ;;
            *foot*)
              hyprctl dispatch exec -- \
                foot --app-id=org.leenix.screensaver \
                --config="$LEENIX_PATH/default/foot/screensaver.ini" \
                -e leenix-screensaver
              ;;
            *kitty*)
              hyprctl dispatch exec -- \
                kitty --class=org.leenix.screensaver \
                --override font_size=18 \
                --override window_padding_width=0 \
                -e leenix-screensaver
              ;;
            *)
              notify-send -u low "✋  Screensaver only runs in Alacritty, Foot, Ghostty, or Kitty"
              ;;
          esac
        done

        hyprctl dispatch focusmonitor $focused
      '';
    })
  ];
}