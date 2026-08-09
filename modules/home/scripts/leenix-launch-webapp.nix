{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-webapp";
      excludeShellChecks = [ "SC2046" "SC2086" ];

      runtimeInputs = with pkgs; [
        xdg-utils
        gnused
        coreutils
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch a URL as a web app in the default supported browser

        # leenix:args=

        browser=$(xdg-settings get default-web-browser)

        case $browser in
          google-chrome* | brave* | microsoft-edge* | opera* | vivaldi* | helium*) ;;
          *) browser="chromium.desktop" ;;
        esac

        exec setsid uwsm-app -- $(sed -n 's/^Exec=\([^ ]*\).*/\1/p' \
          {~/.local,~/.nix-profile,/usr}/share/applications/$browser \
          2>/dev/null | head -1) \
          --app="$1" "''${@:2}"
      '';
    })
  ];
}