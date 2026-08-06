{
  config,
  lib,
  vars,
  ...
}:

lib.mkIf (lib.attrByPath [ "hardware" "nvidia" "enable" ] false vars) {
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "vscode"
    ];

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    open = true;
    modesetting.enable = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    nvidiaSettings = true;

    prime = {
      inherit (vars.hardware.nvidia.prime) intelBusId nvidiaBusId;

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
