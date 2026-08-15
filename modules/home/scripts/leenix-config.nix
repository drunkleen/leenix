{
  lib,
  pkgs,
  ...
}:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-config";
      excludeShellChecks = [ "SC2086" "SC2016" ];

      runtimeInputs = with pkgs; [
        coreutils
        gnused
        gawk
        gnugrep
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Manage LEENIX machine policy: local declarative overrides merged over host defaults, with build/switch transactions.

        # leenix:args=<get|set|unset|dns|overrides|rebuild|switch> [key] [value]

        # leenix:hidden=true

        set -euo pipefail

        # Canonical mutable LEENIX source checkout. Exported so the impure
        # flake evaluation (--impure) can read hosts/<host>/local.nix.
        LEENIX_SRC=''${LEENIX_SRC:-$HOME/nix-config}
        export LEENIX_SRC
        HOST=''${LEENIX_HOST:-$(hostname)}
        VARS="$LEENIX_SRC/hosts/$HOST/variables.nix"
        LOCAL="$LEENIX_SRC/hosts/$HOST/local.nix"

        debug() {
          [[ -n ''${LEENIX_DEBUG:-} ]] && echo "leenix-config: $*" >&2 || true
        }

        die() {
          echo "leenix-config: $*" >&2
          exit 1
        }

        require_src() {
          [[ -d $LEENIX_SRC ]] || die "source checkout not found: $LEENIX_SRC (set LEENIX_SRC to override)"
          [[ -f $VARS ]] || die "host variables not found: $VARS (host '$HOST', set LEENIX_HOST to override)"
        }

        # Current overrides held in the local policy file (controlled schema).
        OV_timezone=""
        OV_locale_lang=""
        OV_locale_region=""
        OV_dns_mode=""
        OV_dns_servers=()

        read_overrides() {
          OV_timezone=""
          OV_locale_lang=""
          OV_locale_region=""
          OV_dns_mode=""
          OV_dns_servers=()

          # Missing local.nix is the normal first-run state: no overrides.
          [[ -f $LOCAL ]] || return 0

          OV_timezone=$(sed -n 's/^  timezone = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
          OV_locale_lang=$(sed -n 's/^    language = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
          OV_locale_region=$(sed -n 's/^    region = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
          OV_passwordless_sudo=$(sed -n 's/^    passwordlessSudo = \(true\|false\);$/\1/p' "$LOCAL" | head -1)

          # Legacy locale schema (`default = "X";` + LC_* extra): migrate to the
          # two-dimension model deterministically (language = region = old value).
          local legacy_default
          legacy_default=$(sed -n 's/^    default = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
          if [[ -n $legacy_default ]]; then
            [[ -z $OV_locale_lang ]] && OV_locale_lang="$legacy_default"
            [[ -z $OV_locale_region ]] && OV_locale_region="$legacy_default"
          fi

          # New structured DNS block: networking.dns = { mode = ...; servers = [...]; }
          if grep -qE '^    dns = \{' "$LOCAL"; then
            OV_dns_mode=$(sed -n 's/^      mode = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
            mapfile -t OV_dns_servers < <(awk '
              /^      servers = \[/ { in_servers = 1; next }
              in_servers && /^      \];/ { in_servers = 0; next }
              in_servers { gsub(/^        "/, ""); gsub(/"$/, ""); print }
            ' "$LOCAL")
            return 0
          fi

          # Legacy provider-string override (old schema): migrate it safely.
          local legacy
          legacy=$(sed -n 's/^    dns = "\(.*\)";$/\1/p' "$LOCAL" | head -1)
          if [[ -n $legacy ]]; then
            case "$legacy" in
              system) : ;;
              cloudflare) OV_dns_mode="custom"; OV_dns_servers=(1.1.1.1 1.0.0.1) ;;
              quad9) OV_dns_mode="custom"; OV_dns_servers=(9.9.9.9 149.112.112.112) ;;
              google) OV_dns_mode="custom"; OV_dns_servers=(8.8.8.8 8.8.4.4) ;;
              adguard) OV_dns_mode="custom"; OV_dns_servers=(94.140.14.14 94.140.15.15) ;;
              *)
                die "legacy networking.dns override '$legacy' in $LOCAL is not recognized; run 'leenix-config dns system' to reset it"
                ;;
            esac
          fi
        }

        # Regenerate the local override file from the current override map.
        # Deterministic and small; only known menu-editable keys are managed.
        write_local() {
          mkdir -p "$(dirname "$LOCAL")"
          local tmp="$LOCAL.tmp"
          {
            echo "{"
            [[ -n $OV_timezone ]] && echo "  timezone = \"$OV_timezone\";"
            if [[ -n $OV_locale_lang || -n $OV_locale_region ]]; then
              echo "  locale = {"
              [[ -n $OV_locale_lang ]] && echo "    language = \"$OV_locale_lang\";"
              [[ -n $OV_locale_region ]] && echo "    region = \"$OV_locale_region\";"
              echo "  };"
            fi
            if [[ -n $OV_dns_mode ]]; then
              echo "  networking = {"
              echo "    dns = {"
              echo "      mode = \"$OV_dns_mode\";"
            if [[ ''${#OV_dns_servers[@]} -gt 0 ]]; then
              echo "      servers = ["
              for s in "''${OV_dns_servers[@]}"; do
                echo "        \"$s\""
              done
              echo "      ];"
            fi
            echo "    };"
            echo "  };"
          fi
          if [[ -n $OV_passwordless_sudo ]]; then
            echo "  security = {"
            echo "    passwordlessSudo = $OV_passwordless_sudo;"
            echo "  };"
          fi
          echo "}"
        } > "$tmp"
        if grep -qE 'timezone =|locale =|networking =|security =' "$tmp"; then
            mv "$tmp" "$LOCAL"
          else
            rm -f "$tmp"
            rm -f "$LOCAL"
          fi
        }

        rollback_local() {
          if [[ -f $LOCAL.leenix-backup ]]; then
            mv "$LOCAL.leenix-backup" "$LOCAL"
          else
            rm -f "$LOCAL"
          fi
        }

        # Effective value = host defaults recursively merged with local overrides.
        get_value() {
          local key="$1" keypath joiner=""
          case "$key" in
            timezone) keypath="timezone" ;;
            locale.language) keypath="locale.language" ;;
            locale.region) keypath="locale.region" ;;
            networking.dns | networking.dns.mode) keypath="networking.dns.mode" ;;
            networking.dns.servers) keypath="networking.dns.servers"; joiner=" " ;;
            *) die "unsupported key: $key (supported: timezone, locale.language, locale.region, networking.dns[.mode|.servers])" ;;
          esac

          local expr
          if [[ -n $joiner ]]; then
            expr=$(
              cat <<'EXPR'
let
  vars = import __VARS__;
  local = if builtins.pathExists __LOCAL__ then import __LOCAL__ else {};
  merge = a: b: a // builtins.mapAttrs (k: v: if builtins.isAttrs v && builtins.isAttrs (a.''${k} or {}) then merge a.''${k} v else v) b;
in
  builtins.concatStringsSep __SEP__ (merge vars local).__KEYPATH__
EXPR
            )
            expr=''${expr//__SEP__/\"$joiner\"}
          else
            expr=$(
              cat <<'EXPR'
let
  vars = import __VARS__;
  local = if builtins.pathExists __LOCAL__ then import __LOCAL__ else {};
  merge = a: b: a // builtins.mapAttrs (k: v: if builtins.isAttrs v && builtins.isAttrs (a.''${k} or {}) then merge a.''${k} v else v) b;
in
  (merge vars local).__KEYPATH__
EXPR
            )
          fi
          expr=''${expr//__VARS__/\"$VARS\"}
          expr=''${expr//__LOCAL__/\"$LOCAL\"}
          expr=''${expr//__KEYPATH__/$keypath}
          nix eval --impure --raw --expr "$expr" 2>/dev/null
        }

        transaction() {
          # Validate the local override (absent = defaults only, nothing to validate).
          if [[ -f $LOCAL ]] && ! nix eval --impure --file "$LOCAL" >/dev/null 2>&1; then
            rollback_local
            die "local override did not evaluate; previous state restored"
          fi
          # Build once as user (local policy visible), activate the exact
          # result as root. leenix-system-apply: exit 1 = build failed
          # (rollback), exit 2 = activation failed (keep new valid policy).
          if ! leenix-system-apply; then
            rc=$?
            if [[ $rc -eq 2 ]]; then
              rm -f "$LOCAL.leenix-backup"
              die "build succeeded but activation failed; local override left at the new valid state"
            fi
            rollback_local
            die "build failed; local override restored to previous state"
          fi
          rm -f "$LOCAL.leenix-backup"
        }

        cmd_set() {
          local key="$1" value="$2"
          require_src
          [[ -n $value ]] || die "set requires a value"
          if [[ -f $LOCAL ]]; then
            cp -a "$LOCAL" "$LOCAL.leenix-backup"
          fi
          read_overrides
          case "$key" in
            timezone) OV_timezone="$value" ;;
            locale.language)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config locale language <locale>' for language"
              ;;
            locale.region)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config locale region <locale>' for region"
              ;;
            networking.dns)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config dns <system|preset <name>|custom <ip...>|show>' for DNS"
              ;;
            *) rm -f "$LOCAL.leenix-backup"; die "unsupported key: $key (supported: timezone)" ;;
          esac
          write_local
          debug "$key -> $value (local override)"
          transaction
          echo "leenix-config: $key is now '$value'"
        }

        cmd_unset() {
          local key="$1"
          require_src
          if [[ -f $LOCAL ]]; then
            cp -a "$LOCAL" "$LOCAL.leenix-backup"
          fi
          read_overrides
          case "$key" in
            timezone) OV_timezone="" ;;
            locale.language)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config locale reset language' to reset language"
              ;;
            locale.region)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config locale reset region' to reset region"
              ;;
            networking.dns)
              rm -f "$LOCAL.leenix-backup"
              die "use 'leenix-config dns system' to reset DNS"
              ;;
            *) rm -f "$LOCAL.leenix-backup"; die "unsupported key: $key" ;;
          esac
          write_local
          debug "unset $key (falls back to host default)"
          if [[ -f $LOCAL ]] || [[ -f $LOCAL.leenix-backup ]]; then
            transaction
          fi
          echo "leenix-config: $key reset to host default"
        }

        valid_ip() {
          local ip="$1"
          if [[ $ip =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
            local a b c d
            IFS=. read -r a b c d <<<"$ip"
            [[ $a -le 255 && $b -le 255 && $c -le 255 && $d -le 255 ]]
          elif [[ $ip =~ ^[0-9a-fA-F:]+$ && $ip == *:* ]]; then
            true
          else
            false
          fi
        }

        # Write a custom DNS override (mode=custom + ordered servers) and run
        # the transaction. $@ are the validated server addresses.
        dns_set_custom() {
          local -a srv=()
          local s
          [[ $# -ge 1 ]] || die "dns custom requires at least one address"
          for s in "$@"; do
            # valid_ip restricts to digits/dots/colons/hex, which are always
            # safe as Nix string contents, so values serialize without escaping.
            valid_ip "$s" || die "invalid DNS server address: '$s'"
            srv+=("$s")
          done
          if [[ -f $LOCAL ]]; then
            cp -a "$LOCAL" "$LOCAL.leenix-backup"
          fi
          read_overrides
          OV_dns_mode="custom"
          OV_dns_servers=("''${srv[@]}")
          write_local
          debug "dns -> custom (''${srv[*]})"
          transaction
          echo "leenix-config: DNS set to custom (''${srv[*]})"
        }

        cmd_dns_preset() {
          local name="$1" srv=()
          case "$name" in
            cloudflare) srv=(1.1.1.1 1.0.0.1) ;;
            quad9) srv=(9.9.9.9 149.112.112.112) ;;
            google) srv=(8.8.8.8 8.8.4.4) ;;
            adguard) srv=(94.140.14.14 94.140.15.15) ;;
            *) die "unknown DNS preset: $name (cloudflare quad9 google adguard)" ;;
          esac
          dns_set_custom "''${srv[@]}"
        }

        cmd_dns() {
          local action=''${1:-}
          require_src
          case "$action" in
            system | reset)
              # Remove the DNS override entirely so the host default (System/DHCP) applies.
              if [[ -f $LOCAL ]]; then
                cp -a "$LOCAL" "$LOCAL.leenix-backup"
              fi
              read_overrides
              OV_dns_mode=""
              OV_dns_servers=()
              write_local
              debug "dns -> system (host default)"
              if [[ -f $LOCAL ]] || [[ -f $LOCAL.leenix-backup ]]; then
                transaction
              fi
              echo "leenix-config: DNS set to System/DHCP"
              ;;
            preset)
              [[ -n ''${2:-} ]] || die "usage: leenix-config dns preset <cloudflare|quad9|google|adguard>"
              cmd_dns_preset "$2"
              ;;
            custom)
              shift
              dns_set_custom "$@"
              ;;
            show)
              printf 'mode: %s\n' "$(get_value networking.dns.mode)"
              printf 'servers: %s\n' "$(get_value networking.dns.servers)"
              ;;
            *)
              die "usage: leenix-config dns <system|reset|preset <name>|custom <ip...>|show>"
              ;;
          esac
        }

        cmd_overrides() {
          require_src
          read_overrides
          [[ -n $OV_timezone ]] && echo "timezone = $OV_timezone"
          [[ -n $OV_locale_lang ]] && echo "locale.language = $OV_locale_lang"
          [[ -n $OV_locale_region ]] && echo "locale.region = $OV_locale_region"
          if [[ -n $OV_dns_mode ]]; then
            echo "networking.dns.mode = $OV_dns_mode"
            echo "networking.dns.servers = ''${OV_dns_servers[*]}"
          fi
        }

        # Set one locale dimension (language or region) and run the transaction.
        locale_set_dimension() {
          local which="$1" value="$2"
          require_src
          [[ -n $value ]] || die "usage: leenix-config locale $which <locale>"
          if [[ -f $LOCAL ]]; then
            cp -a "$LOCAL" "$LOCAL.leenix-backup"
          fi
          read_overrides
          if [[ $which == "language" ]]; then
            OV_locale_lang="$value"
          else
            OV_locale_region="$value"
          fi
          write_local
          debug "locale.$which -> $value"
          transaction
          echo "leenix-config: locale.$which is now '$value'"
          echo "Locale changed. Relogin required for the entire session to use the new locale."
        }

        cmd_locale() {
          local action=''${1:-}
          case "$action" in
            language)
              locale_set_dimension language "''${2:-}"
              ;;
            region)
              locale_set_dimension region "''${2:-}"
              ;;
            show)
              require_src
              printf 'language: %s\n' "$(get_value locale.language)"
              printf 'region: %s\n' "$(get_value locale.region)"
              ;;
            reset)
              local which=''${2:-}
              require_src
              case "$which" in
                language | region)
                  if [[ -f $LOCAL ]]; then
                    cp -a "$LOCAL" "$LOCAL.leenix-backup"
                  fi
                  read_overrides
                  if [[ $which == "language" ]]; then
                    OV_locale_lang=""
                  else
                    OV_locale_region=""
                  fi
                  write_local
                  debug "locale.$which -> host default"
                  if [[ -f $LOCAL ]] || [[ -f $LOCAL.leenix-backup ]]; then
                    transaction
                  fi
                  echo "leenix-config: locale.$which reset to host default"
                  echo "Locale changed. Relogin required for the entire session to use the new locale."
                  ;;
                *)
                  die "usage: leenix-config locale reset <language|region>"
                  ;;
              esac
              ;;
            *)
              die "usage: leenix-config locale <language <locale>|region <locale>|show|reset <language|region>>"
              ;;
          esac
        }

        cmd_rebuild() {
          require_src
          leenix-system-apply
        }

        cmd_switch() {
          require_src
          leenix-system-apply
        }

        cmd_sudo_passwordless() {
          local action=''${1:-}
          require_src
          case "$action" in
            on|enable)
              if [[ -f $LOCAL ]]; then cp -a "$LOCAL" "$LOCAL.leenix-backup"; fi
              read_overrides
              OV_passwordless_sudo=true
              write_local
              transaction
              echo "leenix-config: passwordless sudo enabled"
              ;;
            off|disable)
              if [[ -f $LOCAL ]]; then cp -a "$LOCAL" "$LOCAL.leenix-backup"; fi
              read_overrides
              OV_passwordless_sudo=""
              write_local
              transaction
              echo "leenix-config: passwordless sudo disabled"
              ;;
            status)
              require_src
              local val
              val=$(sed -n 's/^    passwordlessSudo = \(true\|false\);$/\1/p' "$LOCAL" 2>/dev/null | head -1)
              if [[ $val == true ]]; then echo enabled; else echo disabled; fi
              ;;
            *)
              die "usage: leenix-config sudo-passwordless <on|off|status>"
              ;;
          esac
        }

        case "''${1:-}" in
          get)
            [[ -n ''${2:-} ]] || die "usage: leenix-config get <key>"
            require_src
            printf '%s\n' "$(get_value "$2")"
            ;;
          set)
            [[ -n ''${2:-} && -n ''${3:-} ]] || die "usage: leenix-config set <key> <value>"
            cmd_set "$2" "$3"
            ;;
          unset)
            [[ -n ''${2:-} ]] || die "usage: leenix-config unset <key>"
            cmd_unset "$2"
            ;;
          dns) shift; export LEENIX_TITLE="Apply DNS settings"; cmd_dns "$@" ;;
          locale) shift; export LEENIX_TITLE="Apply language & region"; cmd_locale "$@" ;;
          sudo-passwordless) shift; export LEENIX_TITLE="Apply sudo policy"; cmd_sudo_passwordless "$@" ;;
          overrides) cmd_overrides ;;
          rebuild) export LEENIX_TITLE="LEENIX Rebuild"; cmd_rebuild ;;
          switch) export LEENIX_TITLE="Switch configuration"; cmd_switch ;;
          *)
            echo "Usage: leenix-config <get|set|unset|dns|locale|sudo-passwordless|overrides|rebuild|switch> [key] [value]" >&2
            echo "  keys: timezone | locale.language | locale.region | networking.dns[.mode|.servers]" >&2
            echo "  dns: leenix-config dns <system|reset|preset <name>|custom <ip...>|show>" >&2
            echo "  locale: leenix-config locale <language <locale>|region <locale>|show|reset <language|region>>" >&2
            echo "  sudo-passwordless: leenix-config sudo-passwordless <on|off|status>" >&2
            exit 1
            ;;
        esac
      '';
    })
  ];
}
