{
  config,
  lib,
  vars,
  ...
}:

lib.mkIf (lib.attrByPath [ "hardware" "cpu" "intel" "enable" ] false vars) {
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
