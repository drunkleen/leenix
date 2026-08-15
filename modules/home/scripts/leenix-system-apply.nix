{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-system-apply";
      excludeShellChecks = [ "SC2086" "SC2012" ];

      runtimeInputs = with pkgs; [
        coreutils
        git
        gnugrep
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
        # Stage UI: Preflight / Build system / Activate system / Finalize. Raw
        # build/activation output is captured to a bounded log; only the failing
        # stage's output is shown by default (everything with LEENIX_DEBUG=1).
        #
        # LEENIX_TITLE   stage header label (default: "LEENIX Rebuild")
        # LEENIX_DEBUG   stream raw output live while still logging
        #
        # Exit codes:
        #   0  success
        #   1  preflight/build failed
        #   2  build succeeded but activation failed

        set -uo pipefail
        set +e

        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC
        HOST=''${LEENIX_HOST:-$(hostname)}
        TITLE=''${LEENIX_TITLE:-LEENIX Rebuild}
        VERBOSE=''${LEENIX_DEBUG:-}

        LOG_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/leenix/logs"
        LOG_FILE="$LOG_DIR/apply-$(date +%Y%m%d-%H%M%S).log"
        cap=$(mktemp)
        pathf=$(mktemp)
        trap 'rm -f "$cap" "$pathf"' EXIT
        mkdir -p "$LOG_DIR"

        TOTAL=4
        CURRENT=0

        stage_begin() {
          CURRENT=$((CURRENT + 1))
          printf '  [%d/%d] %-18s' "$CURRENT" "$TOTAL" "$1"
          if [[ -n $VERBOSE ]]; then printf '\n'; fi
        }

        stage_mark() {
          if [[ -n $VERBOSE ]]; then
            printf '  %s\n' "$1"
          else
            printf ' %s\n' "$1"
          fi
        }

        dump_failure() {
          printf '\n%s failed.\n\n---- output ----\n' "$1"
          if [[ -n $VERBOSE ]]; then
            cat "$LOG_FILE"
          else
            cat "$cap"
          fi
          printf '%s\n' '--------------------'
        }

        run_preflight() {
          stage_begin "Preflight"
          local rc=0 warn=""
          {
            [[ -d $LEENIX_SRC && -f $LEENIX_SRC/flake.nix ]] || {
              echo "Source checkout not found: $LEENIX_SRC"
              rc=1
            }
            [[ -n $HOST ]] || {
              echo "Could not determine host name"
              rc=1
            }
            if [[ $rc -eq 0 ]] && git -C "$LEENIX_SRC" status --porcelain 2>/dev/null | grep -q .; then
              warn="Git working tree is dirty"
            fi
          } >"$cap" 2>&1
          cat "$cap" >>"$LOG_FILE"
          if [[ -n $VERBOSE ]]; then cat "$cap"; fi
          if [[ $rc -ne 0 ]]; then
            stage_mark "✗"
            return 1
          fi
          if [[ -n $warn ]]; then
            stage_mark "⚠"
            printf '      %s\n' "$warn"
          else
            stage_mark "✓"
          fi
          return 0
        }

        run_build() {
          stage_begin "Build system"
          local rc=0
          system=""
          if [[ -n $VERBOSE ]]; then
            if nix build \
              --impure \
              --no-link \
              --print-out-paths \
              --extra-experimental-features 'nix-command flakes' \
              "$LEENIX_SRC#nixosConfigurations.$HOST.config.system.build.toplevel" \
              2> >(tee -a "$LOG_FILE" >&2) | tail -1 >"$pathf"; then
              system=$(cat "$pathf")
            else
              rc=1
            fi
          else
            if nix build \
              --impure \
              --no-link \
              --print-out-paths \
              --extra-experimental-features 'nix-command flakes' \
              "$LEENIX_SRC#nixosConfigurations.$HOST.config.system.build.toplevel" \
              2>"$cap" | tail -1 >"$pathf"; then
              system=$(cat "$pathf")
              cat "$cap" >>"$LOG_FILE"
            else
              rc=1
            fi
          fi
          if [[ $rc -ne 0 || -z $system || ! -d $system ]]; then
            stage_mark "✗"
            return 1
          fi
          stage_mark "✓"
          printf '      %s\n' "$system"
          return 0
        }

        run_activate() {
          stage_begin "Activate system"
          local rc=0
          if [[ -n $VERBOSE ]]; then
            if ! sudo nix-env --profile /nix/var/nix/profiles/system --set "$system" 2>&1 | tee -a "$LOG_FILE"; then
              rc=1
            elif ! sudo env NIXOS_INSTALL_BOOTLOADER=1 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
              "$system/bin/switch-to-configuration" switch 2>&1 | tee -a "$LOG_FILE"; then
              rc=1
            fi
          else
            if ! sudo nix-env --profile /nix/var/nix/profiles/system --set "$system" 2>&1 | tee "$cap" >/dev/null; then
              rc=1
            elif ! sudo env NIXOS_INSTALL_BOOTLOADER=1 LANG=C.UTF-8 LC_ALL=C.UTF-8 \
              "$system/bin/switch-to-configuration" switch 2>&1 | tee -a "$cap" >/dev/null; then
              rc=1
            fi
            cat "$cap" >>"$LOG_FILE"
          fi
          if [[ $rc -ne 0 ]]; then
            stage_mark "✗"
            return 1
          fi
          stage_mark "✓"
          return 0
        }

        run_finalize() {
          stage_begin "Finalize"
          ls -1t "$LOG_DIR"/apply-*.log 2>/dev/null | tail -n +6 | xargs -r rm -f || true
          stage_mark "✓"
          return 0
        }

        printf '%s\n\n' "$TITLE"

        if ! run_preflight; then
          dump_failure "Preflight"
          echo "Full log: $LOG_FILE"
          exit 1
        fi
        if ! run_build; then
          dump_failure "Build system"
          echo "Full log: $LOG_FILE"
          exit 1
        fi
        if ! run_activate; then
          dump_failure "Activate system"
          echo "Full log: $LOG_FILE"
          exit 2
        fi
        run_finalize
        exit 0
      '';
    })
  ];
}
