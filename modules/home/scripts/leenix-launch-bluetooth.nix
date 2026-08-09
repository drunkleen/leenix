{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-bluetooth";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix bluetooth controls TUI (provided by bluetui).

        rfkill unblock bluetooth
        exec leenix-launch-or-focus-tui bluetui
      '';
    })
  ];
}