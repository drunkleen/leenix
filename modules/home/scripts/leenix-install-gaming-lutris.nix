{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-gaming-lutris";

      runtimeInputs = with pkgs; [
        coreutils
        gnused
        util-linux
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Install Lutris with Wine + DXVK for running Windows games (Battle.net, EA, Ubisoft Connect, etc.)

        # leenix:requires-sudo=true

        set -e

        echo "Installing Lutris..."
        leenix-pkg-add lutris umu-launcher wine-staging wine-mono wine-gecko winetricks python-protobuf
        leenix-install-gaming-gpu-lib32

        # Lutris ships with `#!/usr/bin/env python3`, which resolves to mise's Python and
        # fails to import the lutris module. Pin the shebang to the system Python.

        sudo sed -i '/env python3/ c#!/bin/python3' /usr/bin/lutris

        cat <<'EOF'

        Lutris will open and auto-fetch its DXVK and VKD3D runtimes in the background
        (watch the bottom status bar). Once that finishes, click the + to add or install games.

        EOF

        setsid lutris >/dev/null 2>&1 &
      '';
    })
  ];
}