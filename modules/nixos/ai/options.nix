{ lib, ... }:

# Generated typed options for the AI catalog:
#   leenix.ai.<category>.<leaf>.enable
# Derived entirely from catalog.nix.
let
  catalog = import ./catalog.nix;
in
{
  options.leenix.ai = builtins.mapAttrs (cat: leaves:
    builtins.mapAttrs (leaf: meta:
      lib.mkOption {
        type = lib.types.submodule {
          options.enable = lib.mkEnableOption meta.description;
        };
        default = { };
        description = "Declarative AI capability: ${meta.description}.";
      }) leaves) catalog;
}
