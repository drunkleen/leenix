{
  config,
  lib,
  vars,
  ...
}:

lib.mkIf vars.hardware.cpu.intel.enable {
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
