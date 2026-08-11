{ pkgs, ... }:

{
  home.packages = [
    pkgs.zathura
    (pkgs.writeShellApplication {
      name = "leenix-launch-document";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default document viewer (zathura).

        exec ${pkgs.uwsm}/bin/uwsm app -t scope -- ${pkgs.zathura}/bin/zathura "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";
  };
}
