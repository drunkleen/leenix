{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update-confirm";

      runtimeInputs = with pkgs; [
        gum
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Prompt for confirmation before starting an update

        gum style \
          --border normal \
          --padding "1 2" \
          "Ready to update?" \
          "" \
          "• You cannot stop the update once you start!" \
          "• Make sure you're connected to power or have a full battery" \
          "" \
          "What's new: https://github.com/basecamp/leenix/releases"

        echo

        if ! gum confirm "Continue with update?"; then
          echo "Update cancelled"
          exit 1
        fi
      '';
    })
  ];
}