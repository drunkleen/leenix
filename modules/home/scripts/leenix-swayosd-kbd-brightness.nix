{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-swayosd-kbd-brightness";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Display keyboard backlight state as discrete graphical segments using SwayOSD.

        # leenix:args=<current> <max>

        # leenix:examples=leenix swayosd kbd brightness 0 3 | leenix swayosd kbd brightness 1 3 | leenix swayosd kbd brightness 3 3

        current=''${1:-}
        max=''${2:-}

        if [[ -z $current || -z $max || $max -lt 1 ]]; then
          echo "Usage: leenix-swayosd-kbd-brightness <current> <max>" >&2
          exit 1
        fi

        (( current > max )) && current=$max

        # Suppress duplicate renders: the hardware watcher and the manual
        # command path can both observe the same transition within ~250ms.

        state_dir="$HOME/.local/state/leenix"
        mkdir -p "$state_dir"
        state_file="$state_dir/kbd-osd-last"
        last_ns="0"
        last_val="-1"
        if [[ -f "$state_file" ]]; then
          read -r last_ns last_val < "$state_file" || true
        fi
        now_ns="$(date +%s%N)"
        if (( now_ns - last_ns < 500000000 )) && [[ "$current" == "$last_val" ]]; then
          exit 0
        fi
        printf '%s %s\n' "$now_ns" "$current" > "$state_file"

        leenix-swayosd-client \
          --custom-icon keyboard-brightness-symbolic \
          --custom-segmented-progress "''${current}:''${max}"
      '';
    })
  ];
}
