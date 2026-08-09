{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-theme-update";

      runtimeInputs = with pkgs; [
        git
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update user-installed git themes

        for dir in ~/.config/leenix/themes/*/; do
          if [[ -d $dir ]] && [[ ! -L ''${dir%/} ]] && [[ -d $dir/.git ]]; then
            echo "Updating: $(basename "$dir")"
            git -C "$dir" pull
          fi
        done
      '';
    })
  ];
}