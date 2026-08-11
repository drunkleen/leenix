{
  config,
  lib,
  pkgs,
  ...
}:

let
  leenixTheme = import ./plymouth {
    inherit (pkgs) stdenvNoCC;
  };
in

{
  config = lib.mkIf config.leenix.boot.plymouth.enable {
    boot.plymouth = {
      enable = true;
      theme = "leenix";
      themePackages = [ leenixTheme ];
    };
  };
}
