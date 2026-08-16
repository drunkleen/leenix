{
  pkgs,
  variables,
  ...
}:

# LEENIX-branded system identity. The kernel release and hostname are queried
# dynamically from the running system (never baked at build time). The kernel
# POLICY channel (--policy) comes from the centrally passed merged host
# variables (the same `variables` every home module already receives), so no
# host-specific special argument is needed. Coreutils `uname` is untouched.

let
  kernelPolicy = ((variables.boot or { }).kernel or { }).channel or "default";
in

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-uname";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=LEENIX-branded system identity (kernel + host), dynamically read

        # leenix:args=[--policy]

        set -euo pipefail

        release=$(uname -r)
        nodename=$(uname -n)

        if [[ "''${1:-}" == "--policy" ]]; then
          echo "Linux Leenix $release ($nodename)"
          echo "Kernel policy: ${kernelPolicy}"
        else
          echo "Linux Leenix $release ($nodename)"
        fi
      '';
    })
  ];
}
