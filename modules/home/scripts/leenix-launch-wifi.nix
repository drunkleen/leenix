{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-launch-wifi";

      runtimeInputs = with pkgs; [
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Launch the Leenix wifi controls (provided by the Impala TUI).

        rfkill unblock wifi
        leenix-launch-or-focus-tui impala
      '';
    })
  ];
}