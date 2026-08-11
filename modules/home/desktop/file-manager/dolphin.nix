{ pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers
    ark
    (pkgs.writeShellApplication {
      name = "leenix-launch-file-manager";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured file manager (Dolphin).

        # Launch via UWSM service mode so the app inherits the centralized
        # systemd/UWSM activation environment (declarative Qt/KDE theme vars)
        # instead of arbitrary/stale calling-shell environment.
        # Scope/app mode would inherit the caller env (e.g. stale
        # QT_STYLE_OVERRIDE) and break dark mode.
        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.kdePackages.dolphin}/bin/dolphin "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."inode/directory" = "org.kde.dolphin.desktop";
}
