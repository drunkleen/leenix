{ ... }:

{
  # Development helpers. Installed only when the development profile is
  # enabled (leenix.profiles.development.enable). Not part of the universal base.
  imports = [
    ./leenix-dev-add-migration.nix
    ./leenix-dev-benchmark.nix
    ./leenix-dev-bin-metadata.nix
    ./leenix-dev-scaffold.nix
  ];
}
