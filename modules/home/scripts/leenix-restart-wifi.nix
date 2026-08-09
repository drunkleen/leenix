{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-wifi";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Unblock and restart the Wi-Fi service.

        echo -e "Unblocking wifi...\n"
        rfkill unblock wifi
        rfkill list wifi
      '';
    })
  ];
}