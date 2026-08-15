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

        # 1) Build once as user, capturing the exact toplevel store path. The
        # build log is streamed to the terminal (tee) so the user sees progress
        # during what can be a multi-minute build, while still being captured for
        # the failure dump. Without this, a long build looks frozen. The exit
        # status is captured explicitly so failures always report instead of
        # being swallowed by `set -e` mid-substitution.
        echo "Building the LEENIX system... this may take a while."
        build_log=$(mktemp)
        set +e
        system=$(nix build \
          --impure \
          --no-link \
          --print-out-paths \
          --extra-experimental-features 'nix-command flakes' \
          "$LEENIX_SRC#nixosConfigurations.$HOST.config.system.build.toplevel" \
          2> >(tee "$build_log" >&2) | tail -1)
        build_status=$?
        set -e
        if [[ $build_status -ne 0 || -z $system || ! -d $system ]]; then
          echo "leenix-system-apply: build failed (see output above)" >&2
          rm -f "$build_log"
          exit 1
        fi
        rm -f "$build_log"
        echo "BUILT: $system"

        # 2) Activate the exact built closure (privilege boundary). A neutral,
        # always-valid locale (C.UTF-8) is used ONLY for the activation command
        # so stale shell locale env (e.g. a just-reset de_DE.UTF-8) cannot make
        # the Perl-based activation scripts warn ("Setting locale failed").
        if ! sudo nix-env --profile /nix/var/nix/profiles/system --set "$system"; then
          echo "leenix-system-apply: profile update failed" >&2
          exit 2
        fi
        if ! sudo env NIXOS_INSTALL_BOOTLOADER=1 LANG=C.UTF-8 LC_ALL=C.UTF-8 "$system/bin/switch-to-configuration" switch; then
          echo "leenix-system-apply: activation failed" >&2
          exit 2
        fi
        echo "ACTIVATED: $system"
      '';
    })
  ];
}
