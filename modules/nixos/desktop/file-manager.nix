{ config, lib, ... }:

{
  config = lib.mkIf config.leenix.profiles.desktop.enable {
    services.udisks2.enable = true;
  };
}
