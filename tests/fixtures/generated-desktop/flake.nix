# True external-consumer fixture flake.
#
# Consumes LEENIX Core ONLY as a flake input through its public constructor
# `leinix-core.lib.mkInstance`. Used standalone to demonstrate/mirror the
# repository a future installer would generate.
#
# NOTE on recursive-check avoidance: this fixture lives inside the Core
# repository, so root `nix flake check` does not recurse into THIS flake (that
# would create a Core <-> fixture cycle). Instead the root check evaluates the
# same policy via mkInstance directly (see flake.nix `checks` in the repo root).
# This file exists for external-consumer parity/standalone use.
{
  description = "Neutral generated LEENIX desktop instance (external-consumer fixture)";

  inputs = {
    # Core consumed as an external flake. In a real generated repository this
    # would be `github:<org>/leenix`; for this in-repo fixture the nested path
    # must not be relied on for root-check evaluation.
    leenix-core = {
      url = "path:../../..";
      flake = true;
    };
  };

  outputs = { self, leenix-core, ... }: {
    nixosConfigurations.generated-desktop =
      leenix-core.lib.mkInstance {
        system = "x86_64-linux";
        modules = [
          ./hardware.nix
          ./policy.nix
        ];
      };
  };
}
