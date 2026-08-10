{
  config,
  lib,
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
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    boot.kernelModules = [
      "nvidia"
      "nvidia_modeset"
      "nvidia_drm"
    ];
  };
}
