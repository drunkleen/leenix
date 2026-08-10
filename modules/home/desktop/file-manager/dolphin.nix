{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    ark
    (pkgs.writeShellApplication {
      name = "leenix-launch-file-manager";

      runtimeInputs = with pkgs; [
        coreutils
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured file manager (Dolphin).

        exec setsid uwsm-app -- ${pkgs.kdePackages.dolphin}/bin/dolphin "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
}
