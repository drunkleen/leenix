{ config, lib, ... }:

# Development profile gatekeeper.
#
# Importing this profile loads the development package composition
# (modules/nixos/development/default.nix). The composition only installs
# packages for enabled leenix.development.<category>.<leaf> leaves. Options,
# profile-gating/unfree/platform assertions and catalog checks are always loaded
# via modules/nixos/core/options.nix, so an enabled leaf with the profile off
# fails evaluation even if this profile were not imported.
{
  imports = [ ../modules/nixos/development ];

  config = lib.mkIf config.leenix.profiles.development.enable { };
}
