{ pkgs, systemConfig}:

import ./apps.nix {
  inherit pkgs systemConfig;
}
