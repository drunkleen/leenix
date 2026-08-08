{ ... }:

{
  home.file.".local/bin/hypr-zoom" = {
    executable = true;

    text = ''
      #!/usr/bin/env bash

      # Toggle / zoom in / zoom out for Hyprland (uses cursor:zoom_factor)

      STEP=0.3
      MIN=1.0
      MAX=10.0

      CUR=$(hyprctl getoption cursor:zoom_factor -j | jq -r '.float')

      case "$1" in
        toggle)
          if (( $(echo "$CUR == 1.0" | bc -l) )); then
            NEW=1.7
          else
            NEW=1.0
          fi
          ;;
        in)
          NEW=$(echo "$CUR + $STEP" | bc)
          if (( $(echo "$NEW > $MAX" | bc -l) )); then NEW=$MAX; fi
          ;;
        out)
          NEW=$(echo "$CUR - $STEP" | bc)
          if (( $(echo "$NEW < $MIN" | bc -l) )); then NEW=$MIN; fi
          ;;
        *)
          echo "Usage: $0 {toggle|in|out}"
          exit 1
          ;;
      esac

      hyprctl keyword cursor:zoom_factor "$NEW"
    '';
  };
}
