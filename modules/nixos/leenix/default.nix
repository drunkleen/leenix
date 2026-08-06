{ lib, ... }:

{
  options.leenix = {
    desktop.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable the current Leenix desktop capability profile.";
    };

    shell = {
      enable = lib.mkEnableOption "the parallel Leenix Quickshell session";

      sessionName = lib.mkOption {
        type = lib.types.str;
        default = "Leenix";
        description = "Display name for the parallel Leenix session.";
      };

      stateDirectory = lib.mkOption {
        type = lib.types.str;
        default = "leenix";
        description = "Relative XDG state directory for the Leenix shell.";
      };
    };
  };
}
