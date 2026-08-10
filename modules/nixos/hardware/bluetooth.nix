{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };
}
