{ lib, ... }:

# Generated typed options for the development catalog:
#   leenix.development.<category>.<leaf>.enable
# Derived entirely from catalog.nix — no manual 198-option list.
let
  catalog = import ./catalog.nix;
in
{
  options.leenix.development = builtins.mapAttrs (cat: leaves:
    builtins.mapAttrs (leaf: meta:
      lib.mkOption {
        type = lib.types.submodule {
          options.enable = lib.mkEnableOption meta.description;
        };
        default = { };
        description = "Declarative development capability: ${meta.description}.";
      }) leaves) catalog;
}
