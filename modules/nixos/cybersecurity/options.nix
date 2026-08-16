{ lib, ... }:

# Generated typed options for the cybersecurity catalog:
#   leenix.cybersecurity.<category>.<leaf>.enable
# Derived entirely from catalog.nix.
let
  catalog = import ./catalog.nix;
in
{
  options.leenix.cybersecurity = builtins.mapAttrs (cat: leaves:
    builtins.mapAttrs (leaf: meta:
      lib.mkOption {
        type = lib.types.submodule {
          options.enable = lib.mkEnableOption meta.description;
        };
        default = { };
        description = "Declarative cybersecurity capability: ${meta.description}.";
      }) leaves) catalog;
}
