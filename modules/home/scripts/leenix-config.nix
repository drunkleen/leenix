{
  lib,
  pkgs,
  leenix,
  ...
}:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config";
      excludeShellChecks = [ "SC2086" "SC2016" ];

      runtimeInputs = with pkgs; [
        coreutils
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Inspect, edit, or apply the configured LEENIX instance policy.

        # leenix:args=<get|show|status|overrides|edit|set|unset|dns|locale|sudo-passwordless|rebuild|switch> [key] [value]

        # leenix:hidden=true

        # This tool is format-agnostic. It never parses or rewrites policy
        # structure: it reads effective values from the evaluated configuration
        # and lets you edit the typed policy file (leinix.instance.policyPath)
        # in your editor. Applying changes is an explicit `rebuild`/`switch`.

        set -uo pipefail

        # Canonical instance metadata (baked from the typed leenix.instance.*
        # tree passed via the Home Manager bridge).
        FLAKE="${leenix.instance.flakePath}"
        CONFIG_NAME="${leenix.instance.configurationName}"
        POLICY="${leenix.instance.policyPath}"
        EDITOR_CMD=''${EDITOR:-vi}

        debug() {
          [[ -n ''${LEENIX_DEBUG:-} ]] && echo "leenix-config: $*" >&2 || true
        }

        die() {
          echo "leenix-config: $*" >&2
          exit 1
        }

        require_instance() {
          [[ -d $FLAKE ]] || die "instance checkout not found: $FLAKE (edit leenix.instance.flakePath in policy to override)"
          [[ -f $POLICY ]] || die "instance policy not found: $POLICY (edit leenix.instance.policyPath in policy to override)"
        }

        # Read an effective value from the built config (no source-path inference).
        get_value() {
          local keypath="$1"
          case "$keypath" in
            timezone) keypath="host.timezone" ;;
          esac
          nix eval --impure --raw --expr "let f = builtins.getFlake \"$FLAKE\"; in f.nixosConfigurations.$CONFIG_NAME.config.leenix.$keypath" 2>/dev/null \
            || die "unable to evaluate leenix.$keypath from the built instance config"
        }

        # Open the policy file with $EDITOR. Best-effort navigation for a key:
        # absent keys are normal in sparse policy and must never be an error.
        open_editor() {
          local key=''${1:-}
          if [[ -n $key ]]; then
            local line
            line=$(grep -n -F "\"$key\"" "$POLICY" 2>/dev/null | head -1 | cut -d: -f1 || true)
            if [[ -n $line ]]; then
              case "$EDITOR_CMD" in
                *vi*|*emacs*|*nano*)
                  "$EDITOR_CMD" "+$line" "$POLICY" 2>/dev/null
                  return
                  ;;
              esac
            fi
          fi
          "$EDITOR_CMD" "$POLICY"
        }

        cmd_status() {
          require_instance
          echo "configuration: $CONFIG_NAME"
          echo "flake path:    $FLAKE"
          echo "policy path:   $POLICY"
          echo "timezone = $(get_value timezone 2>/dev/null || echo default)"
          echo "locale.language = $(get_value locale.language 2>/dev/null || echo default)"
          echo "locale.region = $(get_value locale.region 2>/dev/null || echo default)"
          echo "networking.dns.mode = $(get_value networking.dns.mode 2>/dev/null || echo default)"
          echo "networking.dns.servers = $(get_value networking.dns.servers 2>/dev/null || echo default)"
          echo "security.passwordlessSudo = $(get_value security.passwordlessSudo 2>/dev/null || echo default)"
        }

        # Name-to-key mapping used by the editor wrappers to pick a sensible anchor.
        key_for() {
          case "$1" in
            timezone) echo timezone ;;
            language|locale.language) echo language ;;
            region|locale.region) echo region ;;
            dns|networking.dns|networking.dns.mode) echo dns ;;
            sudo|passwordless|passwordlesssudo|security.passwordlessSudo) echo passwordlessSudo ;;
            *) echo ""
          esac
        }

        cmd_edit() {
          local key=''${1:-}
          require_instance
          if [[ -n $key ]]; then
            open_editor "$key"
          else
            open_editor
          fi
        }

        # Editor-first wrappers: they open the policy source for editing and
        # explain the semantics. They never mutate values automatically.
        cmd_set() {
          local key="$1"
          require_instance
          local anchor
          anchor=$(key_for "$key")
          open_editor "$anchor"
          echo "leenix-config: opened $POLICY. Edit the value for '$key' in the editor, save, then run 'leenix-config rebuild' (or 'leenix-config switch') to apply." >&2
        }

        cmd_unset() {
          local key="$1"
          require_instance
          local anchor
          anchor=$(key_for "$key")
          open_editor "$anchor"
          echo "leenix-config: opened $POLICY. To reset '$key', remove its line: an omitted option inherits the Core/profile default (sparse policy semantics)." >&2
        }

        cmd_dns() {
          local action=''${1:-}
          require_instance
          case "$action" in
            show)
              printf 'mode: %s\n' "$(get_value networking.dns.mode 2>/dev/null || echo default)"
              printf 'servers: %s\n' "$(get_value networking.dns.servers 2>/dev/null || echo none)"
              ;;
            *)
              open_editor dns
              echo "leenix-config: opened $POLICY at networking DNS policy. Edit mode/servers in the editor, then run 'leenix-config rebuild' to apply." >&2
              ;;
          esac
        }

        cmd_locale() {
          local dimension=''${1:-}
          require_instance
          case "$dimension" in
            show)
              printf 'language: %s\n' "$(get_value locale.language 2>/dev/null || echo default)"
              printf 'region: %s\n' "$(get_value locale.region 2>/dev/null || echo default)"
              ;;
            language) open_editor language ;;
            region) open_editor region ;;
            *) open_editor ;;
          esac
          if [[ -n $dimension && $dimension != show ]]; then
            echo "leenix-config: opened $POLICY at locale.$dimension settings. Edit in the editor, then run 'leenix-config rebuild' to apply. A relogin may be needed for the session to adopt the new locale." >&2
          fi
        }

        cmd_sudo_passwordless() {
          local action=''${1:-}
          require_instance
          case "$action" in
            status)
              if get_value security.passwordlessSudo 2>/dev/null | grep -q true; then
                echo enabled
              else
                echo disabled
              fi
              ;;
            on|enable|off|disable|"")
              open_editor passwordlessSudo
              echo "leenix-config: opened $POLICY at security.passwordlessSudo. Set it to true (enabled) or false (disabled), save, then run 'leenix-config rebuild' to apply." >&2
              ;;
            *)
              die "usage: leenix-config sudo-passwordless <on|off|status>"
              ;;
          esac
        }

        cmd_rebuild() {
          require_instance
          leenix-system-apply
        }

        cmd_switch() {
          require_instance
          leenix-system-apply
        }

        case "''${1:-}" in
          get)
            [[ -n ''${2:-} ]] || die "usage: leenix-config get <path>"
            require_instance
            get_value "$2"
            ;;
          show|status|overrides) cmd_status ;;
          edit)
            shift
            cmd_edit "$@"
            ;;
          set)
            [[ -n ''${2:-} ]] || die "usage: leenix-config set <key> [value]"
            cmd_set "$2"
            ;;
          unset)
            [[ -n ''${2:-} ]] || die "usage: leenix-config unset <key>"
            cmd_unset "$2"
            ;;
          dns) shift; export LEENIX_TITLE="Configure DNS"; cmd_dns "$@" ;;
          locale) shift; export LEENIX_TITLE="Configure language & region"; cmd_locale "$@" ;;
          sudo-passwordless) shift; export LEENIX_TITLE="Configure sudo policy"; cmd_sudo_passwordless "$@" ;;
          rebuild) export LEENIX_TITLE="LEENIX Rebuild"; cmd_rebuild ;;
          switch) export LEENIX_TITLE="Switch configuration"; cmd_switch ;;
          *)
            cat >&2 <<'EOF'
Usage: leenix-config <command> [key] [value]

Read:
  get <path>                show effective config.leenix.<path>
  show | status             show effective instance summary
  overrides                 alias of status (compatibility)

Edit (opens policy source in $EDITOR; never changes values automatically):
  edit [key]                open the typed policy; best-effort anchor at key
  set <key> [value]         open policy near the setting
  unset <key>               open policy near the setting (omit = inherit default)
  dns [show]                configure networking DNS (opens policy)
  locale [language|region]  configure locale (opens policy)
  sudo-passwordless <on|off|status>

Apply:
  rebuild                   build and switch the instance
  switch                    build and switch the instance

A missing option in policy.nix means the Core/profile default applies.
EOF
            exit 1
            ;;
        esac
      '';
    })
  ];
}