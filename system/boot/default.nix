{ pkgs, systemConfig, variables }:

import ./apps.nix {
  inherit pkgs systemConfig;
}
