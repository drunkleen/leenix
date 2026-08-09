{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hw-touchpad";

      runtimeInputs = with pkgs; [
        hyprland
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print the detected Hyprland touchpad or trackpad device name

        device=$(hyprctl devices -j | jq -r '[.mice[] | .name | select(test("touchpad|trackpad"; "i"))] | first // empty')
        [[ -n $device ]] && echo "$device"
      '';
    })
  ];
}