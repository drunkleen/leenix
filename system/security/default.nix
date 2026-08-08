{ pkgs, systemConfig }:

let
  hyprlock = import ./hyprlock.nix {
    inherit systemConfig;
  };

  apps = import ./apps.nix {
    inherit pkgs systemConfig;
  };
in
{
  inherit (apps) packages apps;

  pam = hyprlock.pam;
}
