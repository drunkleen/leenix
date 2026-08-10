{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.security.pam.enable {
    security.pam.services.hyprlock = { };
  };
}
