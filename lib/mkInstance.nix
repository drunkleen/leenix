# LEENIX Core -> external instance constructor.
#
# `mkInstance` is the public entrypoint for generating an external machine
# instance from typed `leenix.*` policy. It closes over all of Core's own
# implementation inputs (nixpkgs, Home Manager, Disko, the LEENIX overlay), so
# the caller supplies ONLY instance concerns:
#
#   leenix.lib.mkInstance {
#     system = "x86_64-linux";
#     modules = [ ./hardware-configuration.nix ./policy.nix ];
#     specialArgs = { };   # optional escape hatch
#   }
#
# mkInstance:
#   - never inspects hosts/ or infers a hostname from a path
#   - never imports variables.nix and never uses the legacy variables adapter
#   - injects the full typed LEENIX option tree (core/options.nix)
#   - composes every reusable profile (modules/nixos/profiles.nix)
#   - composes Home Manager (modules/nixos/home-manager.nix) including the typed
#     `leenix` bridge and the Core-owned home composition
#   - composes Disko (modules/nixos/disk/default.nix) from leenix.disk.*
#   - applies the LEENIX overlay automatically
#
# External policy is plain NixOS modules that set typed `leenix.*` options; it
# must not reference `home-manager`, `disko`, `leenfetch`, `overlays`,
# `hosts/`, `variables`, or `tuf-f15`.
{ nixpkgs, home-manager, disko, overlay }:

{
  system ? "x86_64-linux",
  modules,
  specialArgs ? { },
}:

nixpkgs.lib.nixosSystem {
  inherit system specialArgs;

  modules = [
    # LEENIX overlay: same package universe for every instance.
    { nixpkgs.overlays = [ overlay ]; }

    # Home Manager + Disko NixOS modules (Core-owned inputs, closed over here).
    home-manager.nixosModules.home-manager
    disko.nixosModules.disko

    # LEENIX Core composition.
    ../modules/nixos/core/options.nix   # full typed leenix.* option tree
    ../modules/nixos/profiles.nix       # profile implementation (flag-gated)
    ../modules/nixos/home-manager.nix   # HM composition + bridge + user
    ../modules/nixos/disk/default.nix   # Disko layout selection from leenix.disk.*
    ../modules/nixos/boot/default.nix   # boot/visual stack (leenix.boot.* gated)
  ] ++ modules;
}
