{
  pkgs,
  leenix,
  ...
}:

# LEENIX-branded system identity. The kernel release and hostname are queried
# dynamically from the running system (never baked at build time). The kernel
# POLICY channel (--policy) comes from the typed LEENIX policy (typed
  # leenix.* policy -> config.leenix -> HM specialArg `leenix`). Coreutils
  # `uname` is untouched.

let
  kernelPolicy = leenix.boot.kernel.channel;
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
