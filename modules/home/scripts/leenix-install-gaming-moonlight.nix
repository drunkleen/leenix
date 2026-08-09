{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-moonlight";

      runtimeInputs = with pkgs; [
        util-linux
        gtk3
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Moonlight (NVIDIA GameStream / Sunshine client) for streaming games to this PC.

        # leenix:requires-sudo=true

        set -e

        echo "Installing Moonlight..."
        leenix-pkg-add moonlight-qt

        setsid gtk-launch com.moonlight_stream.Moonlight.desktop >/dev/null 2>&1 &
      '';
    })
  ];
}