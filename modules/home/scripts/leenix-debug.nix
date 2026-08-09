{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-debug";
      excludeShellChecks = [ "SC2046" "SC2181" ];

      runtimeInputs = with pkgs; [
        coreutils
        git
        inxi
        systemd
        pacman
        gnugrep
        gnused
        curl
        iputils
        gum
        less
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Print debugging information

        # leenix:args=[--no-sudo] [--print]

        # leenix:examples=leenix debug --print --no-sudo

        # leenix:requires-sudo=true

        NO_SUDO=false
        PRINT_ONLY=false

        while (( $# > 0 )); do
          case "$1" in
            --no-sudo)
              NO_SUDO=true
              shift
              ;;
            --print)
              PRINT_ONLY=true
              shift
              ;;
            *)
              echo "Unknown option: $1"
              echo "Usage: leenix-debug [--no-sudo] [--print]"
              exit 1
              ;;
          esac
        done

        LOG_FILE="/tmp/leenix-debug.log"

        if [[ $NO_SUDO = "true" ]]; then
          DMESG_OUTPUT="(skipped - --no-sudo flag used)"
        else
          DMESG_OUTPUT="$(sudo dmesg)"
        fi

        cat > "$LOG_FILE" <<EOF
        Date: $(date)
        Hostname: $(hostname)
        Leenix Branch: $(git -C "$LEENIX_PATH" branch --show-current 2>/dev/null || echo "unknown")

        $(inxi -Farz)

        $DMESG_OUTPUT

        $(journalctl -b -p 4..1)

        $({ expac -S '%n %v (%r)' $(pacman -Qqe) 2>/dev/null; comm -13 <(pacman -Sql | sort) <(pacman -Qqe | sort) | xargs -r expac -Q '%n %v (AUR)'; } | sort)
        EOF

        if [[ $PRINT_ONLY = "true" ]]; then
          cat "$LOG_FILE"
          exit 0
        fi

        OPTIONS=("View log" "Save in current directory")
        if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
          OPTIONS=("Upload log" "''${OPTIONS[@]}")
        fi

        ACTION=$(gum choose "''${OPTIONS[@]}")

        case "$ACTION" in
          "Upload log")
            echo "Uploading debug log to logs.leenix.org..."
            URL=$(curl -sf -F "file=@$LOG_FILE" https://logs.leenix.org/)
            if (( $? == 0 )) && [[ -n $URL ]]; then
              echo "✓ Log uploaded successfully!"
              echo "Share this URL:"
              echo ""
              echo "  $URL"
            else
              echo "Error: Failed to upload log file"
              exit 1
            fi
            ;;
          "View log")
            less "$LOG_FILE"
            ;;
          "Save in current directory")
            cp "$LOG_FILE" "./leenix-debug.log"
            echo "✓ Log saved to $(pwd)/leenix-debug.log"
            ;;
        esac
      '';
    })
  ];
}