{ pkgs, ... }:

{
  home.packages = [
    pkgs.firefox
    (pkgs.writeShellApplication {
      name = "leenix-launch-browser";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default browser (Firefox).

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
          exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.firefox}/bin/firefox --private-window "''${args[@]}"
        fi

        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.firefox}/bin/firefox "''${args[@]}"
      '';
    })
  ];

  home.sessionVariables.BROWSER = "leenix-launch-browser";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "text/html" = "firefox.desktop";
    "application/xhtml+xml" = "firefox.desktop";
  };
}
