{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-show-done";

      runtimeInputs = with pkgs; [
        gum
        bash
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Display a "Done!" message with a spinner and wait for user to press any key.

        echo
        gum spin --spinner "globe" --title "Done! Press any key to close..." -- bash -c 'read -n 1 -s'
      '';
    })
  ];
}