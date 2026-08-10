{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.intel.enable {
    hardware.cpu.intel.updateMicrocode = true;
  };
}
