{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-default-terminal";

      runtimeInputs = with pkgs; [
        gnugrep
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Set the default terminal used by xdg-terminal-exec

        # leenix:args=[alacritty|foot|ghostty|kitty]

        # leenix:examples=leenix default terminal ghostty | leenix default terminal kitty

        if (($# == 0)); then
          desktop_id=$(grep -vE '^($|#)' ~/.config/xdg-terminals.list 2>/dev/null | head -n 1)
          case "$desktop_id" in
            Alacritty.desktop) echo "alacritty" ;;
            foot.desktop) echo "foot" ;;
            com.mitchellh.ghostty.desktop) echo "ghostty" ;;
            kitty.desktop) echo "kitty" ;;
            *) echo "$desktop_id" ;;
          esac
          exit 0
        fi

        case "$1" in
          alacritty) desktop_id="Alacritty.desktop"; name="Alacritty"; glyph="" ;;
          foot) desktop_id="foot.desktop"; name="Foot"; glyph="" ;;
          ghostty) desktop_id="com.mitchellh.ghostty.desktop"; name="Ghostty"; glyph="" ;;
          kitty) desktop_id="kitty.desktop"; name="Kitty"; glyph="" ;;
          *)
            echo "Usage: leenix-default-terminal <alacritty|foot|ghostty|kitty>"
            exit 1
            ;;
        esac

        cat >~/.config/xdg-terminals.list <<EOF
        # Terminal emulator preference order for xdg-terminal-exec
        # The first found and valid terminal will be used
        $desktop_id
        EOF

        notify-send -u low "$glyph    $name is now the default terminal"
      '';
    })
  ];
}