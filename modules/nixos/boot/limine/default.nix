{ config, lib, ... }:

# LEENIX desktop bootloader: Limine (native NixOS module).
#
# Activation is gated on leenix.boot.loader == "limine"; importing this module
# (via the boot composition layer) is inert for any other selection.
{
  imports = [ ./theme.nix ];

  config = lib.mkIf (config.leenix.boot.loader == "limine") {
    boot.loader = {
      # Exactly one active NixOS bootloader backend.
      systemd-boot.enable = lib.mkDefault false;
      efi.canTouchEfiVariables = lib.mkDefault true;
      limine.enable = true;

      limine = {
        # Do not expose a boot-entry editor (would allow init=/bin/sh).
        enableEditor = false;
        # Keep a sensible number of generations on the ESP (~2 GiB).
        maxGenerations = 10;

        # Instance-owned extra entries (chainloaded OSes, e.g. Windows),
        # supplied via leenix.boot.limine.extraEntries.
        extraEntries = lib.mkIf (config.leenix.boot.limine.extraEntries != null)
          config.leenix.boot.limine.extraEntries;
      };
    };
  };
}