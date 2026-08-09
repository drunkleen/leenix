{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-available-reset";

      runtimeInputs = with pkgs; [
        procps
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Ensure Waybar icon offering the available update is removed

        pkill -RTMIN+7 waybar
        exit 0
      '';
    })
  ];
}