{ pkgs, systemConfig, variables }:

let
  yubikey = import ./yubikey.nix {
    inherit variables;
  };

  sudo = import ./sudo.nix {
    inherit variables;
  };

  hyprlock = import ./hyprlock.nix {
    inherit variables;
  };

  apps = import ./apps.nix {
    inherit pkgs systemConfig variables;
    inherit sudo hyprlock;
  };
in
{
  inherit sudo hyprlock;

  inherit (apps) packages apps;
}
