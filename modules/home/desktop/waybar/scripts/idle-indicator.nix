{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "leenix-waybar-idle-indicator";

  runtimeInputs = with pkgs; [
    procps
  ];

  text = ''
    #!/bin/bash

    if pgrep -x hypridle >/dev/null; then
      echo '{"text": ""}'
    else
      echo '{"text": "󱫖", "tooltip": "Idle lock disabled", "class": "active"}'
    fi
  '';
}
