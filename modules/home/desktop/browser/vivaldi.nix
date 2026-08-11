{ pkgs, ... }:

{
  home.packages = [
    pkgs.vivaldi
    (pkgs.writeShellApplication {
      name = "leenix-launch-browser";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default browser (Vivaldi).

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
          exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.vivaldi}/bin/vivaldi --incognito "''${args[@]}"
        fi

        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.vivaldi}/bin/vivaldi "''${args[@]}"
      '';
    })
  ];

  home.sessionVariables.BROWSER = "leenix-launch-browser";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "vivaldi-stable.desktop";
    "x-scheme-handler/https" = "vivaldi-stable.desktop";
    "text/html" = "vivaldi-stable.desktop";
    "application/xhtml+xml" = "vivaldi-stable.desktop";
  };
}
