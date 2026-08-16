{ config, lib, ... }:

# Applications profile gatekeeper.
#
# Importing this profile loads the applications package composition
# (modules/nixos/applications/default.nix). Options, profile-gating/unfree/
# platform assertions and catalog checks are always loaded via
# modules/nixos/core/options.nix, so an enabled leaf with the profile off fails
# evaluation even if this profile were not imported.
{
  imports = [ ../modules/nixos/applications ];

  config = lib.mkIf config.leenix.profiles.applications.enable { };
}
