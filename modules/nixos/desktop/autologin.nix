{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.desktop.autologin;
in
{
  config = lib.mkIf cfg.enable {
    services.getty = {
      autologinUser = config.leenix.user.username;
      autologinOnce = true;
    };
  };
}
