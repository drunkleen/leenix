{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-pkg-aur-install";
      excludeShellChecks = [ "SC1091" ];

      runtimeInputs = with pkgs; [
        fzf
        yay
        coreutils
        gnused
        findutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Show a fuzzy-finder TUI for picking new AUR packages to install.

        # leenix:requires-sudo=true

        fzf_args=(
          --multi
          --preview 'yay -Siia {1}'
          --preview-label='alt-p: toggle description, alt-b/B: toggle PKGBUILD, alt-j/k: scroll, tab: multi-select'
          --preview-label-pos='bottom'
          --preview-window 'down:65%:wrap'
          --bind 'alt-p:toggle-preview'
          --bind 'alt-d:preview-half-page-down,alt-u:preview-half-page-up'
          --bind 'alt-k:preview-up,alt-j:preview-down'
          --bind 'alt-b:change-preview:yay -Gpa {1} | tail -n +5'
          --bind 'alt-B:change-preview:yay -Siia {1}'
          --color 'pointer:green,marker:green'
        )

        pkg_names=$(yay -Slqa | fzf "''${fzf_args[@]}")

        if [[ -n $pkg_names ]]; then

          # Add aur/ prefix to each package name and convert to space-separated for yay

          source leenix-sudo-keepalive

          echo "$pkg_names" | sed 's/^/aur//' | tr '\n' ' ' | xargs yay -S --noconfirm
          sudo updatedb
          leenix-show-done
        fi
      '';
    })
  ];
}