{
  config,
  lib,
  ...
}:

{
  imports = [
    ../../../disks/laptop-luks-btrfs.nix
    ./mounts.nix
  ];

  config = lib.mkIf (config.leenix.disk.layout == "laptop-luks-btrfs") {
  };
}
