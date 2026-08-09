{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-restart-bluetooth";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Unblock and restart the bluetooth service.

        echo -e "Unblocking bluetooth...\n"
        rfkill unblock bluetooth
        rfkill list bluetooth
      '';
    })
  ];
}