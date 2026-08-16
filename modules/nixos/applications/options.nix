{ lib, ... }:

# Generated typed options for the applications catalog:
#   leenix.applications.<category>.<leaf>.enable
# Derived entirely from catalog.nix.
let
  catalog = import ./catalog.nix;
in
{
  options.leenix.applications = builtins.mapAttrs (cat: leaves:
    builtins.mapAttrs (leaf: meta:
      lib.mkOption {
        type = lib.types.submodule {
          options.enable = lib.mkEnableOption meta.description;
        };
        default = { };
        description = "Declarative optional application: ${meta.description}.";
      }) leaves) catalog;
}
