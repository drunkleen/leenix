{ pkgs, ... }:

# `leenix packages audit` — report-only freshness audit for the development,
# cybersecurity and AI catalogs.
#
# Architecture:
#   catalogs → Nix-generated static registry (embedded here at build time)
#            → `leenix packages audit` → optional upstream queries
#
# The registry is built from the canonical catalogs (no duplicated leaf lists)
# and contains: domain, capability, pinned version, source classification and
# upstream homepage. The command NEVER modifies Nix files, flake.lock,
# packages or HOME, and NEVER runs during normal evaluation/build — network
# lookups happen only when the user explicitly runs `leenix packages audit`.
# On lookup failure it reports latest=unknown / status=unknown (never guesses).
let
  catalogs = {
    development = import ../../nixos/development/catalog.nix;
    cybersecurity = import ../../nixos/cybersecurity/catalog.nix;
    ai = import ../../nixos/ai/catalog.nix;
  };

  iterate = domain: catalog:
    builtins.concatLists (map (cat: map (leaf: {
      inherit domain cat leaf;
      meta = catalog.${cat}.${leaf};
    }) (builtins.attrNames catalog.${cat})) (builtins.attrNames catalog));

  leafInfo = x:
    let
      attempted = if (x.meta.packages or null) != null then builtins.tryEval (x.meta.packages pkgs) else { success = false; value = [ ]; };
      p = if attempted.success then (builtins.head (attempted.value ++ [ null ])) else null;
      # Coerce package metadata to plain strings for JSON; never propagate a
      # function/thunk into the registry.
      asStr = v: if builtins.isString v then v else if builtins.isInt v || builtins.isBool v then builtins.toString v else "";
    in
    {
      capability = "${x.domain}.${x.cat}.${x.leaf}";
      pinnedVersion = if p != null then (asStr (p.version or (builtins.toString (p.name or "")))) else "";
      source = if (x.meta.classification or "") == "E" then "external" else if p != null then "nixpkgs" else "unknown";
      upstreamHomepage = if p != null then (asStr (p.meta.homepage or "")) else "";
    };

  registry = builtins.map leafInfo (
    builtins.concatLists (map (d: iterate d catalogs.${d}) (builtins.attrNames catalogs))
  );
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-packages-audit";
      runtimeInputs = with pkgs; [
        coreutils
        curl
        gnused
        jq
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Report package freshness for the development, cybersecurity and AI catalogs (report-only).

        # leenix:args=[--online]

        set -uo pipefail

        REGISTRY=$(cat <<'LEENIX_JSON'
${builtins.toJSON registry}
LEENIX_JSON
)

        ONLINE=0
        for a in "$@"; do
          case "$a" in
            --online) ONLINE=1 ;;
            *) echo "Unknown option: $a" >&2; echo "Usage: leenix-packages-audit [--online]" >&2; exit 1 ;;
          esac
        done

        printf '%-46s %-14s %-9s %-14s %s\n' "capability" "pinned" "source" "latest" "status"
        echo "$REGISTRY" | jq -r '.[] | [.capability,.pinnedVersion,.source,.upstreamHomepage] | @tsv' | while IFS=$'\t' read -r cap pin src hp; do
          latest=""
          status="unknown"
          if (( ONLINE )); then
            if [[ -n $hp && $hp == *github.com* ]]; then
              repo=$(printf '%s' "$hp" | sed -E 's#https?://github.com/([^/]+/[^/]+).*#\1#')
              latest=$(curl -fsSL --max-time 10 "https://api.github.com/repos/$repo/releases/latest" 2>/dev/null | jq -r '.tag_name // ""' 2>/dev/null || true)
              if [[ -n $latest ]]; then
                if [[ $latest == "v$pin" || $latest == "$pin" ]]; then
                  status="current"
                else
                  status="outdated"
                fi
              fi
            fi
          fi
          printf '%-46s %-14s %-9s %-14s %s\n' "$cap" "$pin" "$src" "''${latest:-unknown}" "$status"
        done
      '';
    })
  ];
}
