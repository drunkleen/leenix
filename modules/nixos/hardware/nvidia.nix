{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.nvidia.enable {
    services.xserver.videoDrivers = [
      "nvidia"
    ];

    hardware.nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = true;
      nvidiaSettings = true;

      prime = {
        offload.enable = true;
        # PRIME render offload: the desktop runs on the Intel iGPU; explicitly
        # offloaded programs use the RTX 3050. Generates `nvidia-offload`.
        offload.enableOffloadCmd = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];

    environment.systemPackages = [
      # Familiar NVIDIA-offload alias: prime-run <cmd> -> nvidia-offload <cmd>.
      (pkgs.writeShellApplication {
        name = "prime-run";
        text = ''
          #!/bin/bash

          # leenix:summary=Run a command on the NVIDIA GPU via PRIME render offload.

          exec nvidia-offload "$@"
        '';
      })
    ];
  };
}
