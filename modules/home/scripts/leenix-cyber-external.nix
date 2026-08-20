{ pkgs, lib, leenix, ... }:

# Thin integration launchers for E-classification (external/commercial)
# cybersecurity tools. For every ENABLED E leaf a `leenix-<leaf>` launcher is
# installed that:
#   - detects a legitimately user-installed executable
#   - launches it when present
#   - otherwise prints actionable setup guidance (exit 1)
#
# It NEVER downloads binaries, bundles licenses, stores license keys, bypasses
# activation/licensing or cracks software.
let
  catalog = import ../../nixos/cybersecurity/catalog.nix;
  cybPolicy = leenix.cybersecurity;
  allLeaves = builtins.concatLists (map (cat: map (leaf: {
    inherit cat leaf;
    meta = catalog.${cat}.${leaf};
  }) (builtins.attrNames catalog.${cat})) (builtins.attrNames catalog));
  eEnabled = builtins.sort builtins.lessThan (
    map (x: x.leaf) (builtins.filter (x:
      x.meta.classification == "E" && cybPolicy.${x.cat}.${x.leaf}.enable
    ) allLeaves)
  );
  leafToCat = builtins.listToAttrs (map (x: { name = x.leaf; value = x.cat; }) allLeaves);
  mkName = leaf: "leenix-${lib.toLower leaf}";
  launcher = leaf:
    let
      meta = catalog.${leafToCat.${leaf}}.${leaf};
      launcherName = mkName leaf;
    in
    pkgs.writeShellApplication {
      name = launcherName;
      text = ''
        #!/bin/bash

        # leenix:summary=Launch the externally-installed '${leaf}' tool (commercial/external integration).

        set -uo pipefail

        exe="${meta.integration.exe}"
        if command -v "$exe" >/dev/null 2>&1; then
          exec "$exe" "$@"
        fi

        echo "LEENIX: '${leaf}' is not installed (external/commercial tool)." >&2
        echo "${meta.integration.setup}" >&2
        exit 1
      '';
    };
in
{
  home.packages = map launcher eEnabled;
}
