{ pkgs, variables, ... }:

# LEENIX wordlist discovery helper (cybersecurity profile).
#
#   leenix-wordlists list
#     -> prints ENABLED wordlists and their canonical system-profile paths
#   leenix-wordlists path <name>
#     -> prints the path ONLY if that wordlist is enabled
#        disabled wordlist -> "not enabled on this host" (exit 1)
#        unknown name      -> "Unknown LEENIX wordlist" (exit 1)
#
# The enabled mapping + resource paths are baked from Nix policy/catalog
# metadata at build time — no runtime /nix/store scanning. Wordlists install
# DATA only; nothing is ever auto-fed into a cracker/scanner.
let
  catalog = import ../../nixos/cybersecurity/catalog.nix;
  wlPolicy = variables.cybersecurity.wordlists or { };
  known = builtins.attrNames catalog.wordlists;
  enabled = builtins.sort builtins.lessThan (
    builtins.filter (n: (wlPolicy.${n} or false)) known
  );
  wlEntry = n: "  WL[${n}]=/run/current-system/sw/${catalog.wordlists.${n}.resourcePath}";
  wlLines = builtins.concatStringsSep "\n" (map wlEntry enabled);
  knownList = builtins.concatStringsSep " " known;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-wordlists";
      runtimeInputs = with pkgs; [ coreutils ];

      text = ''
        #!/bin/bash

        # leenix:summary=List enabled LEENIX wordlists and their canonical paths.

        # leenix:args=<list|path <name>>

        set -uo pipefail

        KNOWN="${knownList}"
        declare -A WL
${wlLines}

        usage() {
          echo "Usage: leenix-wordlists list | path <name>"
          echo "Known wordlists: ${knownList}"
        }

        cmd=''${1:-}
        case "$cmd" in
          list)
            for n in "''${!WL[@]}"; do
              printf '%s %s\n' "$n" "''${WL[$n]}"
            done | sort
            ;;
          path)
            name=''${2:-}
            if [[ -z $name ]]; then
              usage
              exit 1
            fi
            if [[ -v WL[$name] ]]; then
              printf '%s\n' "''${WL[$name]}"
            elif case " $KNOWN " in
              *" $name "*) true ;;
              *) false ;;
            esac; then
              echo "LEENIX wordlist '$name' is not enabled on this host." >&2
              exit 1
            else
              echo "Unknown LEENIX wordlist: $name" >&2
              usage
              exit 1
            fi
            ;;
          *)
            usage
            exit 1
            ;;
        esac
      '';
    })
  ];
}
