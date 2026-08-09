{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-zed";

      runtimeInputs = with pkgs; [
        util-linux
        gtk3
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Zed Editor and configure it with the current Leenix theme

        echo "Installing Zed Editor..."
        leenix-pkg-add zed omazed

        # Apply Leenix theme to Zed

        omazed setup

        setsid gtk-launch dev.zed.Zed
      '';
    })
  ];
}