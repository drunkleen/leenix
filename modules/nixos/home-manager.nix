{ config, lib, ... }:

# LEENIX Home Manager composition (Core-owned).
#
# Responsibilities (single-user model):
#   - instantiate one Home Manager user from the typed policy:
#       leenix.user.username      -> home-manager.users.<username>
#       leenix.user.homeDirectory (consumed inside home/default.nix)
#   - import the Core-owned Home composition (home/default.nix), so external
#     instances never reference internal home module paths.
#   - rely on the Core home-manager bridge (core/home-manager.nix) to provide
#     `home-manager.extraSpecialArgs.leenix = config.leenix`.
#
# This module is safe only when a `user.username` is configured. An incomplete
# instance policy (empty username) fails with an actionable assertion rather
# than constructing an invalid `home-manager.users."".` attrset.
let
  cfg = config.leenix;
  user = cfg.user.username;
  configured = builtins.isString user && user != "";
in
{
  imports = [
    # The typed `<-> Home Manager bridge.
    ./core/home-manager.nix
  ];

  config = {
    assertions = [
      {
        assertion = configured;
        message = "LEENIX Home Manager composition requires leenix.user.username to be set (non-empty).";
      }
    ];

    home-manager = lib.mkIf configured {
      useGlobalPkgs = true;
      useUserPackages = true;

      users.${user} = import ../../home;
    };
  };
}
