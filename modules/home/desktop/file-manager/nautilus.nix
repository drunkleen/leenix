{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    gvfs
    (pkgs.writeShellApplication {
      name = "leenix-launch-file-manager";

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the configured file manager (Nautilus).

        # Launch via UWSM service mode so the app inherits the centralized
        # systemd/UWSM activation environment (declarative theme vars)
        # instead of arbitrary/stale calling-shell environment.
        # Scope/app mode would inherit the caller env and break appearance.
        exec ${pkgs.uwsm}/bin/uwsm app -t service -- ${pkgs.nautilus}/bin/nautilus "$@"
      '';
    })
  ];

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications."inode/directory" = "org.gnome.Nautilus.desktop";
}
