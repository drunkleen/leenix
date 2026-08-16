{ config, lib, pkgs, ... }:

# Package composition for the AI catalog. Imported by profiles/ai.nix.
# Only `environment.systemPackages` is touched: no services, daemons, ports,
# firewall, drivers, model downloads, or mutable installers. Local runtimes
# install the binary only; models stay user/runtime state.
let
  catalog = import ./catalog.nix;
  aiLib = import ./lib.nix { inherit catalog; };
  ai = config.leenix.ai;

  isEnabled = x: ((ai.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) aiLib.all;

  rawLeafPkgs = x:
    if x.meta.guarded then
      let
        attempt = builtins.tryEval (x.meta.packages pkgs);
      in
      if attempt.success then
        builtins.filter (p: p != null && lib.meta.availableOn pkgs.stdenv.hostPlatform p) attempt.value
      else
        [ ]
    else
      x.meta.packages pkgs;

  packages = builtins.concatLists (map rawLeafPkgs enabled);
in
{
  config = lib.mkIf config.leenix.profiles.ai.enable {
    environment.systemPackages = packages;
  };
}
