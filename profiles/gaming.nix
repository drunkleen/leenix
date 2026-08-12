{ config, lib, ... }:

{
  imports = [
    ../modules/nixos/desktop/gaming.nix
  ];

  config = lib.mkIf config.leenix.profiles.gaming.enable {
  };
}
