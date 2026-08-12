{
  lib,
  pkgs,
  variables,
  ...
}:

let
  # crowned.png is the canonical default LEENIUM wallpaper. It must exist in
  # the repository; missing it is a configuration error, not a fallback case.
  # (guarded by the assert below)

  # Repository-owned LEENIUM wallpapers. Any image file placed in ./wallpapers
  # becomes a built-in and is installed to ~/.config/leenix/backgrounds/.
  # crowned.png is one of those built-ins and doubles as the first-install
  # default; no wallpaper is generated at build time.
  wallpaperDir = ./wallpapers;
  wallpaperFiles =
    if builtins.pathExists wallpaperDir then
      lib.filterAttrs
        (name: type: type == "regular" && lib.any (ext: lib.hasSuffix ext name) [
          ".png"
          ".jpg"
          ".jpeg"
          ".webp"
          ".gif"
          ".bmp"
        ])
        (builtins.readDir wallpaperDir)
    else
      { };

  # Apply the current wallpaper through awww. Idempotent first-login
  # initialization (creates the runtime pointer only if absent), waits for the
  # daemon, then displays the current selection on all outputs.
  leenix-wallpaper-refresh = pkgs.writeShellApplication {
    name = "leenix-wallpaper-refresh";

    runtimeInputs = with pkgs; [
      coreutils
      awww
    ];

    text = ''
      #!/bin/bash

      CURRENT_BACKGROUND_LINK="$HOME/.config/leenix/current/background"
      BACKGROUNDS_DIR="$HOME/.config/leenix/backgrounds"
      DEFAULT_BACKGROUND="$BACKGROUNDS_DIR/crowned.png"

      # First-login initialization: only when no current wallpaper exists yet.
      # A user-selected wallpaper (or an existing pointer) is never reset.
      if [[ ! -e "$CURRENT_BACKGROUND_LINK" ]]; then
        mkdir -p "$(dirname "$CURRENT_BACKGROUND_LINK")"
        if [[ -f "$DEFAULT_BACKGROUND" ]]; then
          ln -s "$DEFAULT_BACKGROUND" "$CURRENT_BACKGROUND_LINK"
        fi
      fi

      BACKGROUND="$(readlink -f "$CURRENT_BACKGROUND_LINK" 2>/dev/null || true)"
      if [[ -z $BACKGROUND || ! -f "$BACKGROUND" ]]; then
        echo "No current wallpaper set" >&2
        exit 1
      fi

      # Wait for the awww daemon to be ready (avoids ExecStartPost races).
      for _ in $(seq 1 50); do
        awww query >/dev/null 2>&1 && break
        sleep 0.1
      done

      awww img "$BACKGROUND"
    '';
  };

  leenix-wallpaper-set = pkgs.writeShellApplication {
    name = "leenix-wallpaper-set";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      #!/bin/bash

      if [[ -z ''${1:-} ]]; then
        echo "Usage: leenix-wallpaper-set <path-to-image>" >&2
        exit 1
      fi

      # Absolute path without resolving the final symlink, so current/background
      # keeps pointing at the stable user-visible path (e.g. an HM-managed
      # built-in) instead of an old /nix/store/... target.
      BACKGROUND="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
      CURRENT_BACKGROUND_LINK="$HOME/.config/leenix/current/background"

      if [[ ! -e "$BACKGROUND" ]]; then
        echo "File does not exist: $BACKGROUND" >&2
        exit 1
      fi

      mkdir -p "$(dirname "$CURRENT_BACKGROUND_LINK")"
      ln -nsf "$BACKGROUND" "$CURRENT_BACKGROUND_LINK"

      leenix-wallpaper-refresh
    '';
  };

  # Shared cycle logic for next/previous/random.
  leenix-wallpaper-cycle = pkgs.writeShellApplication {
    name = "leenix-wallpaper-cycle";

    runtimeInputs = with pkgs; [
      coreutils
      findutils
    ];

    text = ''
      #!/bin/bash

      MODE=''${1:-next}
      CURRENT_BACKGROUND_LINK="$HOME/.config/leenix/current/background"

      mapfile -d ''' -t BACKGROUNDS < <(leenix-wallpaper-list)
      TOTAL=''${#BACKGROUNDS[@]}

      if (( TOTAL == 0 )); then
        echo "No backgrounds found in $BACKGROUNDS_DIR" >&2
        exit 1
      fi

      CURRENT_BACKGROUND="$(readlink -f "$CURRENT_BACKGROUND_LINK" 2>/dev/null || true)"
      INDEX=-1
      for i in "''${!BACKGROUNDS[@]}"; do
        if [[ ''${BACKGROUNDS[$i]} == "$CURRENT_BACKGROUND" ]]; then
          INDEX=$i
          break
        fi
      done

      case $MODE in
        random)
          NEW_BACKGROUND=''${BACKGROUNDS[$((RANDOM % TOTAL))]}
          ;;
        prev)
          if (( INDEX == -1 )); then
            NEW_BACKGROUND=''${BACKGROUNDS[0]}
          else
            NEW_BACKGROUND=''${BACKGROUNDS[$(((INDEX - 1 + TOTAL) % TOTAL))]}
          fi
          ;;
        *)
          if (( INDEX == -1 )); then
            NEW_BACKGROUND=''${BACKGROUNDS[0]}
          else
            NEW_BACKGROUND=''${BACKGROUNDS[$(((INDEX + 1) % TOTAL))]}
          fi
          ;;
      esac

      mkdir -p "$(dirname "$CURRENT_BACKGROUND_LINK")"
      ln -nsf "$NEW_BACKGROUND" "$CURRENT_BACKGROUND_LINK"

      leenix-wallpaper-refresh
    '';
  };

  leenix-wallpaper-next = pkgs.writeShellApplication {
    name = "leenix-wallpaper-next";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      #!/bin/bash
      leenix-wallpaper-cycle next
    '';
  };

  leenix-wallpaper-prev = pkgs.writeShellApplication {
    name = "leenix-wallpaper-prev";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      #!/bin/bash
      leenix-wallpaper-cycle prev
    '';
  };

  leenix-wallpaper-random = pkgs.writeShellApplication {
    name = "leenix-wallpaper-random";
    runtimeInputs = with pkgs; [ coreutils ];
    text = ''
      #!/bin/bash
      leenix-wallpaper-cycle random
    '';
  };

  leenix-wallpaper-current = pkgs.writeShellApplication {
    name = "leenix-wallpaper-current";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      #!/bin/bash

      BACKGROUND="$(readlink -f "$HOME/.config/leenix/current/background" 2>/dev/null || true)"
      if [[ -n $BACKGROUND ]]; then
        echo "$BACKGROUND"
      else
        echo "Unknown"
      fi
    '';
  };

  leenix-wallpaper-install = pkgs.writeShellApplication {
    name = "leenix-wallpaper-install";

    runtimeInputs = with pkgs; [
      coreutils
    ];

    text = ''
      #!/bin/bash

      BACKGROUNDS_DIR="$HOME/.config/leenix/backgrounds"
      mkdir -p "$BACKGROUNDS_DIR"
      leenix-launch-file-manager "$BACKGROUNDS_DIR"
    '';
  };

  # Single shared wallpaper discovery (NUL-separated, sorted). Used by the
  # cycle commands and the visual picker so they never disagree.
  leenix-wallpaper-list = pkgs.writeShellApplication {
    name = "leenix-wallpaper-list";

    runtimeInputs = with pkgs; [
      coreutils
      findutils
    ];

    text = ''
      #!/bin/bash

      find -L "$HOME/.config/leenix/backgrounds" -maxdepth 1 -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.webp' \) \
        -print0 2>/dev/null | sort -z
    '';
  };

  # Standalone Quickshell wallpaper picker (mirrors Omarchy's image-picker UX:
  # real image thumbnails, grid navigation, click/Enter applies, Esc cancels).
  wallpaperPicker = pkgs.runCommand "leenix-wallpaper-picker" { } ''
    mkdir -p $out
    cp ${./wallpaper-picker/shell.qml} $out/shell.qml
  '';

  leenix-wallpaper-switcher = pkgs.writeShellApplication {
    name = "leenix-wallpaper-switcher";

    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      vips
      quickshell
    ];

    text = ''
      #!/bin/bash

      CACHE_DIR="''${XDG_CACHE_HOME:-$HOME/.cache}/leenix/wallpaper-previews"
      mkdir -p "$CACHE_DIR"

      mapfile -d ''' -t WALLPAPERS < <(leenix-wallpaper-list)
      if (( ''${#WALLPAPERS[@]} == 0 )); then
        notify-send "No wallpapers found" -t 2000
        exit 1
      fi

      # Build path<TAB>thumbnail<TAB>resolved rows (newline separated).
      ROWS=""
      for img in "''${WALLPAPERS[@]}"; do
        sig="$(stat -Lc '%s:%Y' "$img" 2>/dev/null)" || continue
        hash="$(printf '%s\t%s' "$img" "$sig" | md5sum | cut -d ' ' -f 1)"
        thumb="$CACHE_DIR/$hash.jpg"
        if [[ ! -f "$thumb" ]]; then
          vipsthumbnail "$img" --size 1536x864 --smartcrop=centre --path "''${thumb}[Q=82,strip]" >/dev/null 2>&1 || continue
        fi
        ROWS+="$img"$'\t'"$thumb"$'\t'"$(realpath "$img")"$'\n'
      done

      if [[ -z $ROWS ]]; then
        notify-send "No wallpapers found" -t 2000
        exit 1
      fi

      TMP="$(mktemp -d)"
      LIST="$TMP/list.b64"
      SELECTION="$TMP/selection"
      printf '%s' "$ROWS" | base64 -w 0 > "$LIST"

      LEENIX_WALLPAPER_ROWS_FILE="$LIST" \
      LEENIX_WALLPAPER_SELECTION_FILE="$SELECTION" \
      LEENIX_WALLPAPER_CURRENT="$(readlink -f "$HOME/.config/leenix/current/background" 2>/dev/null || true)" \
        ${pkgs.quickshell}/bin/quickshell --path "${wallpaperPicker}"

      if [[ -s "$SELECTION" ]]; then
        leenix-wallpaper-set "$(cat "$SELECTION")"
      fi
      rm -rf "$TMP"
    '';
  };
in
assert lib.assertMsg
  (lib.pathExists ./wallpapers/crowned.png)
  "modules/home/services/wallpapers/crowned.png is missing (required default LEENIUM wallpaper)";
{
  config = lib.mkIf variables.desktop.hyprland {
    home.packages = with pkgs; [
      awww
      leenix-wallpaper-set
      leenix-wallpaper-next
      leenix-wallpaper-prev
      leenix-wallpaper-random
      leenix-wallpaper-cycle
      leenix-wallpaper-list
      leenix-wallpaper-current
      leenix-wallpaper-refresh
      leenix-wallpaper-install
      leenix-wallpaper-switcher
    ];

    # Repository-owned built-in wallpapers (including crowned.png) land
    # alongside the user-visible library. Individual per-file entries keep the
    # directory writable for user-added wallpapers. No wallpaper is generated
    # at build time; crowned.png is the repo-owned first-install default.
    xdg.configFile =
      lib.mapAttrs'
        (name: _: lib.nameValuePair "leenix/backgrounds/${name}" {
          source = wallpaperDir + "/${name}";
        })
        wallpaperFiles;

    systemd.user.services.awww-daemon = {
      Unit = {
        Description = "AWWW wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.awww}/bin/awww-daemon";
        # Re-apply the current wallpaper after every daemon start (including
        # crash restarts), so a restart restores the selection automatically.
        ExecStartPost = "${leenix-wallpaper-refresh}/bin/leenix-wallpaper-refresh";
        Restart = "on-failure";
        RestartSec = 2;
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
