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
    };
  };
}
