{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-hyprland-monitor-focused-apple";

      runtimeInputs = with pkgs; [
        hyprland
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Return success if the focused Hyprland monitor is an Apple display.

        hyprctl monitors -j | jq -e '.[] | select(.focused == true) | select(.make == "Apple Computer Inc" and (.model | test("StudioDisplay|ProDisplayXDR|Studio XDR")))' >/dev/null
      '';
    })
  ];
}