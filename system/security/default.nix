{ pkgs, systemConfig }:

let
  yubikey = import ./yubikey.nix;

  sudo = import ./sudo.nix {
    inherit yubikey;
  };

  hyprlock = import ./hyprlock.nix {
    inherit yubikey;
  };

  apps = import ./apps.nix {
    inherit pkgs systemConfig;
    inherit sudo hyprlock;
  };
in
{
  inherit sudo hyprlock;

  inherit (apps) packages apps;
}
