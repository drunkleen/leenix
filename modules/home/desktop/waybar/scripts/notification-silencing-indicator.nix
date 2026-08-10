{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "leenix-waybar-notification-silencing-indicator";

  runtimeInputs = with pkgs; [
    mako
    gnugrep
    coreutils
  ];

  text = ''
    #!/bin/bash

    if makoctl mode | grep -q 'do-not-disturb'; then
      echo '{"text": "󰂛", "tooltip": "Notifications silenced", "class": "active"}'
    else
      echo '{"text": ""}'
    fi
  '';
}
