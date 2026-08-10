{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    gvfs
    (pkgs.writeShellApplication {
      name = "leenix-launch-file-manager";

      runtimeInputs = with pkgs; [
        coreutils
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured file manager (Nautilus).

        exec setsid uwsm-app -- ${pkgs.nautilus}/bin/nautilus "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
}
