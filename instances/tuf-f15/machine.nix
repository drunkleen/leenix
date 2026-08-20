{ ... }:

# Instance-owned machine module (tuf-f15).
#
# This module contains ONLY instance-owned standard NixOS state/config.
# Policy lives in ./policy.nix; detected hardware facts live in
# ./hardware-configuration.nix. It deliberately imports NO Core paths.
{
  system.stateVersion = "26.05";
}
