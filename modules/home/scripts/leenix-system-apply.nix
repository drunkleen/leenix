{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-apply";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Build the current LEENIX system exactly once and activate that exact result.

        # leenix:hidden=true

        # Builds config.system.build.toplevel as the normal user (with
        # LEENIX_SRC visible so hosts/<host>/local.nix applies), captures the
        # deterministic store path, then activates THAT exact closure as root.
        # There is exactly ONE evaluation/build; the root step never re-evaluates.
        #
        # Exit codes:
        #   0  success (printed BUILT:/ACTIVATED: paths)
        #   1  build failed
        #   2  build succeeded but activation failed

        set -euo pipefail

        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC
        HOST=''${LEENIX_HOST:-$(hostname)}

        die() {
          echo "leenix-system-apply: $*" >&2
          exit 1
        }

        [[ -d $LEENIX_SRC ]] || die "source checkout not found: $LEENIX_SRC"

        # 1) Build once as user, capturing the exact toplevel store path.
        build_log=$(mktemp)
        system=$(nix build \
          --impure \
          --no-link \
          --print-out-paths \
          --extra-experimental-features 'nix-command flakes' \
          "$LEENIX_SRC#nixosConfigurations.$HOST.config.system.build.toplevel" 2>"$build_log" | tail -1)
        if [[ -z $system || ! -d $system ]]; then
          cat "$build_log" >&2
          rm -f "$build_log"
          exit 1
        fi
        rm -f "$build_log"
        echo "BUILT: $system"

        # 2) Activate the exact built closure (privilege boundary).
        if ! sudo nix-env --profile /nix/var/nix/profiles/system --set "$system"; then
          echo "leenix-system-apply: profile update failed" >&2
          exit 2
        fi
        if ! sudo env NIXOS_INSTALL_BOOTLOADER=1 "$system/bin/switch-to-configuration" switch; then
          echo "leenix-system-apply: activation failed" >&2
          exit 2
        fi
        echo "ACTIVATED: $system"
      '';
    })
  ];
}
