{ pkgs, ... }:

{
  home.packages = [
    pkgs.imv
    (pkgs.writeShellApplication {
      name = "leenix-launch-image";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured default image viewer (imv).

        exec ${pkgs.uwsm}/bin/uwsm app -t scope -- ${pkgs.imv}/bin/imv "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "image/x-farbfeld" = "imv.desktop";
    "image/tiff" = "imv.desktop";
    "image/tiff-fx" = "imv.desktop";
    "image/png" = "imv.desktop";
    "image/x-png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/jpg" = "imv.desktop";
    "image/pjpeg" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/bmp" = "imv.desktop";
    "image/x-bmp" = "imv.desktop";
    "image/heif" = "imv.desktop";
    "image/avif" = "imv.desktop";
    "image/jxl" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/qoi" = "imv.desktop";
  };
}
