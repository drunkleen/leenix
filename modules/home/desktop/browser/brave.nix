{ pkgs, ... }:

{
  home.packages = [
    pkgs.brave
    (pkgs.writeShellApplication {
      name = "leenix-launch-browser";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default browser (Brave).

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
          exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.brave}/bin/brave --incognito "''${args[@]}"
        fi

        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.brave}/bin/brave "''${args[@]}"
      '';
    })
  ];

  home.sessionVariables.BROWSER = "leenix-launch-browser";

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = "brave-browser.desktop";
    "x-scheme-handler/https" = "brave-browser.desktop";
    "text/html" = "brave-browser.desktop";
    "application/xhtml+xml" = "brave-browser.desktop";
  };
}
