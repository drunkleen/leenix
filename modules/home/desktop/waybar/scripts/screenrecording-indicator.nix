{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "leenix-waybar-screenrecording-indicator";

  runtimeInputs = with pkgs; [
    procps
  ];

  text = ''
    #!/bin/bash

    if pgrep -f "^gpu-screen-recorder" >/dev/null; then
      echo '{"text": "󰻂", "tooltip": "Stop recording", "class": "active"}'
    else
      echo '{"text": ""}'
    fi
  '';
}
