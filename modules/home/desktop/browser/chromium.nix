{ pkgs, ... }:

{
  home.packages = [
    pkgs.chromium
    (pkgs.writeShellApplication {
      name = "leenix-launch-browser";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default browser (Chromium).

        args=()
        private=0
        for arg in "$@"; do
          if [[ $arg == "--private" ]]; then
            private=1
          else
            args+=("$arg")
          fi
        done

        if (( private )); then
          exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.chromium}/bin/chromium --incognito "''${args[@]}"
        fi

        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.chromium}/bin/chromium "''${args[@]}"
      '';
    })
  ];

  home.sessionVariables.BROWSER = "leenix-launch-browser";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "chromium-browser.desktop";
    "x-scheme-handler/https" = "chromium-browser.desktop";
    "text/html" = "chromium-browser.desktop";
    "application/xhtml+xml" = "chromium-browser.desktop";
  };
}
