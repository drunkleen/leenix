{ config, lib, ... }:

# Cybersecurity profile gatekeeper.
#
# Importing this profile loads the cybersecurity package composition
# (modules/nixos/cybersecurity/default.nix). Options, profile-gating/unfree/
# platform assertions and catalog checks are always loaded via
# modules/nixos/core/options.nix, so an enabled leaf with the profile off fails
# evaluation even if this profile were not imported.
{
  imports = [ ../modules/nixos/cybersecurity ];

  config = lib.mkIf config.leenix.profiles.cybersecurity.enable { };
}
