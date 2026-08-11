{ pkgs, ... }:

{
  home.packages = [
    pkgs.librewolf
    (pkgs.writeShellApplication {
      name = "leenix-launch-browser";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default browser (LibreWolf).

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
          exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.librewolf}/bin/librewolf --private-window "''${args[@]}"
        fi

        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.librewolf}/bin/librewolf "''${args[@]}"
      '';
    })
  ];

  home.sessionVariables.BROWSER = "leenix-launch-browser";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "librewolf.desktop";
    "x-scheme-handler/https" = "librewolf.desktop";
    "text/html" = "librewolf.desktop";
    "application/xhtml+xml" = "librewolf.desktop";
  };
}
