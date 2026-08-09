{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-touchscreen";

      runtimeInputs = with pkgs; [
        hyprland
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print the detected Hyprland touchscreen or tablet device name

        device=$(hyprctl devices -j | jq -r '[.touch[]?.name, .tablets[]?.name] | first // empty')
        [[ -n $device ]] && echo "$device"
      '';
    })
  ];
}