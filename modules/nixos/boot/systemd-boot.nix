{ config, lib, ... }:

# LEENIX systemd-boot backend (alternative bootloader).
#
# Activation is gated on leenix.boot.loader == "systemd-boot"; importing this
# module (via the boot composition layer) is inert for any other selection.
{
  config = lib.mkIf (config.leenix.boot.loader == "systemd-boot") {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Exactly one active NixOS bootloader backend.
      limine.enable = lib.mkDefault false;
    };
  };
}