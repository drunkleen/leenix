# Neutral evaluation-only hardware declaration for the generated-desktop fixture.
#
# This is a synthetic consumer, not a real machine. It supplies only minimal
# environment-neutral NixOS values needed for successful evaluation. All real
# storage / root filesystem layout is owned by the public Disko policy
# (leenix.disk.*), which is never run here — no device is formatted, mounted or
# wiped. No real hardware identifiers, UUIDs, or machine-specific bus IDs.
{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
