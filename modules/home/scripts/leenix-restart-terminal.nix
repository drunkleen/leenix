{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-terminal";

      runtimeInputs = with pkgs; [
        coreutils
        procps
        psmisc
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Reload supported terminal emulators after config changes

        if [[ -f ~/.config/alacritty/alacritty.toml ]]; then
          touch ~/.config/alacritty/alacritty.toml
        fi

        if pgrep -x kitty >/dev/null; then
          killall -SIGUSR1 kitty >/dev/null
        fi

        if pgrep -x ghostty >/dev/null; then
          killall -SIGUSR2 ghostty
        fi
      '';
    })
  ];
}