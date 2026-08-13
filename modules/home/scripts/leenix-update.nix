{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-update";
      excludeShellChecks = [ "SC2086" ];

      runtimeInputs = with pkgs; [
        git
        coreutils
        libnotify
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Update LEENIX from its git origin: fast-forward only, then build and switch.

        set -euo pipefail

        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC

        cd "$LEENIX_SRC"

        if ! git remote get-url origin 2>/dev/null | grep -qE 'drunkleen/leenix'; then
          notify-send -u critical "LEENIX update aborted: origin is not the LEENIX repository"
          exit 1
        fi

        if [[ -n $(git status --porcelain) ]]; then
          notify-send -u critical "LEENIX update aborted: working tree is dirty"
          exit 1
        fi

        branch=$(git branch --show-current)
        old=$(git rev-parse HEAD)

        git fetch origin

        if ! git merge --ff-only "origin/$branch" >/dev/null 2>&1; then
          notify-send -u critical "LEENIX update aborted: branch is not fast-forwardable (diverged)"
          exit 1
        fi

        new=$(git rev-parse HEAD)
        if [[ $old == "$new" ]]; then
          notify-send -u low "LEENIX is already up to date"
          exit 0
        fi

        echo "LEENIX: $old -> $new ($branch)"

        # Build exactly once (with local.nix applied) and activate the exact
        # result. exit 1 = build failed (rollback git), exit 2 = activation
        # failed (keep the new revision, report).
        if ! leenix-system-apply; then
          rc=$?
          if [[ $rc -eq 2 ]]; then
            notify-send -u critical "LEENIX build succeeded but activation failed ($new)"
            exit 1
          fi
          # Safe rollback: the worktree was clean before the fast-forward merge.
          git reset --hard "$old"
          notify-send -u critical "LEENIX build failed; reverted to previous revision"
          exit 1
        fi

        notify-send -u normal "LEENIX updated and switched ($new)"
      '';
    })
  ];
}
