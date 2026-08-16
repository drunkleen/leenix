{ config, lib, ... }:

# AI profile gatekeeper. Imports the AI package composition. Options,
# profile-gating/unfree/platform assertions and catalog checks are always
# loaded via modules/nixos/core/options.nix.
{
  imports = [ ../modules/nixos/ai ];

  config = lib.mkIf config.leenix.profiles.ai.enable { };
}
