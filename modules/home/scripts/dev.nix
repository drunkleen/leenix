{ ... }:

{
  # Development helpers. Installed only when the development profile is
  # enabled (variables.profiles.development). Not part of the universal base.
  imports = [
    ./leenix-dev-add-migration.nix
    ./leenix-dev-benchmark.nix
    ./leenix-dev-bin-metadata.nix
  ];
}
