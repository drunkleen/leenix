{
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/nixos/desktop/bootstrap.nix
  ];

  config = lib.mkIf config.leenix.profiles.desktop.enable {
    leenix.bootstrap.enable = lib.mkDefault true;
  };
}
