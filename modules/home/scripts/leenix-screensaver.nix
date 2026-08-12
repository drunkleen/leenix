{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-screensaver";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        hyprland
        jq
        coreutils
        terminaltexteffects
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Run the Leenix screensaver using random effects from TTE.

        # The screensaver runs exactly one TTE effect at a time:
        #   start effect -> run to completion -> clear canvas -> next effect
        # A dedicated key watcher on /dev/tty terminates it on ANY keypress.
        # tte is tracked by its explicit PID (never `pkill -x tte`), so only the
        # current child is terminated and unrelated tte sessions are untouched.

        screensaver_in_focus() {
          hyprctl activewindow -j | jq -e '.class == "org.leenix.screensaver"' >/dev/null 2>&1
        }

        # Canonical logo is the single source of truth. A user-custom
        # screensaver.txt (created by `leenix-branding-screensaver image|text`)
        # overrides it when present.
        logo="''${XDG_DATA_HOME:-$HOME/.local/share}/leenix/logo.txt"
        custom="''${XDG_CONFIG_HOME:-$HOME/.config}/leenix/branding/screensaver.txt"
        input_file="$logo"
        [[ -f $custom ]] && input_file="$custom"

        saved_stty=$(stty -g 2>/dev/null || true)
        tte_pid=""
        input_pid=""

        cleanup() {
          # Kill only the tracked children of this screensaver instance.
          [[ -n $tte_pid ]] && kill "$tte_pid" 2>/dev/null || true
          [[ -n $input_pid ]] && kill "$input_pid" 2>/dev/null || true
          # Restore terminal text cursor and line discipline.
          printf '\033[?25h' 2>/dev/null || true
          [[ -n $saved_stty ]] && stty "$saved_stty" 2>/dev/null || true
          # Restore the compositor mouse cursor.
          hyprctl keyword cursor:invisible false &>/dev/null || true
        }
        trap cleanup EXIT
        trap 'exit 130' INT
        trap 'exit 143' TERM
        trap 'exit 129' HUP
        trap 'exit 131' QUIT

        printf '\033]11;rgb:0b/11/13\007'  # LEENIUM background (#0b1113)

        hyprctl keyword cursor:invisible true &>/dev/null

        while true; do
          tte -i "$input_file" \
            --frame-rate 120 \
            --canvas-width 0 \
            --canvas-height 0 \
            --anchor-canvas c \
            --anchor-text c \
            --random-effect \
            --terminal-background-color 0b1113 \
            --no-eol \
            --no-restore-cursor &
          tte_pid=$!

          # Dedicated key watcher: reads the controlling TTY directly so it
          # never competes with tte for stdin. Exits on ANY keypress.
          read -rsn1 < /dev/tty &
          input_pid=$!

          # Wait for the current effect. Exit on keypress or focus loss; when
          # the effect finishes, clear the canvas and start the next one.
          while kill -0 "$tte_pid" 2>/dev/null; do
            if ! kill -0 "$input_pid" 2>/dev/null; then
              exit 0
            fi
            if ! screensaver_in_focus; then
              exit 0
            fi
            sleep 0.05
          done

          # Effect completed: stop the key watcher and reset the canvas.
          kill "$input_pid" 2>/dev/null || true
          input_pid=""
          stty "$saved_stty" 2>/dev/null || true
          printf '\033[2J\033[H'
        done
      '';
    })
  ];
}
