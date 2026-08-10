{
  config,
  lib,
  ...
}:

{
  imports = [
    ../../../disks/laptop-luks-btrfs.nix
  ];

  config = lib.mkIf (config.leenix.disk.layout == "laptop-luks-btrfs") {
  };
}
