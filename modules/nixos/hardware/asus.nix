{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.asus.enable {
    environment.systemPackages = with pkgs; [
      asusctl
    ];

    services.asusd.enable = true;
  };
}
