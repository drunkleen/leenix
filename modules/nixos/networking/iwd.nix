{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.networking.iwd.enable {
    networking.wireless.iwd = {
      enable = true;

      settings = {
        General = {
          EnableNetworkConfiguration = true;
        };
      };
    };
  };
}
