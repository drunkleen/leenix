{
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/nixos/networking/iwd.nix

    ../modules/nixos/hardware/intel.nix
    ../modules/nixos/hardware/asus.nix
    ../modules/nixos/hardware/nvidia.nix
    ../modules/nixos/hardware/bluetooth.nix
    ../modules/nixos/hardware/power-profiles.nix
    ../modules/nixos/hardware/camera.nix

    ../modules/nixos/memory/zram.nix
  ];

  config = lib.mkIf config.leenix.profiles.laptop.enable {
  };
}
