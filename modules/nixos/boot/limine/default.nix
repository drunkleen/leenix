{ lib, ... }:

# LEENIX desktop bootloader: Limine (native NixOS module).
# Replaces systemd-boot as the declaratively-managed NixOS bootloader.
# NOTE: the old systemd-boot EFI files are intentionally left on the ESP as a
# migration recovery path until Limine has booted successfully.
{
  imports = [ ./theme.nix ];

  boot.loader = {
    # Exactly one active NixOS bootloader backend.
    systemd-boot.enable = lib.mkDefault false;
    efi.canTouchEfiVariables = lib.mkDefault true;
    limine.enable = true;
  };

  boot.loader.limine = {
    # Do not expose a boot-entry editor (would allow init=/bin/sh).
    enableEditor = false;
    # Keep a sensible number of generations on the ESP (~2 GiB).
    maxGenerations = 10;
  };
}
