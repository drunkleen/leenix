{
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/nixos/desktop/bootstrap.nix
    ../modules/nixos/desktop/uwsm.nix
    ../modules/nixos/desktop/autologin.nix
    ../modules/nixos/security/pam.nix
  ];

  config = lib.mkIf config.leenix.profiles.desktop.enable {
    leenix.bootstrap.enable = lib.mkDefault true;
  };
}
