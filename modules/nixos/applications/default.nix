{ config, lib, pkgs, ... }:

# Package composition for the applications catalog. Imported by
# profiles/applications.nix. Only `environment.systemPackages` is touched:
# no systemd services, no networking/firewall/ports, no users/groups, no
# virtualisation backends, no daemon enablement, no secrets. packageOnly
# leaves are treated identically (package installation only) — the metadata is
# a caveat, not an implementation switch.
let
  catalog = import ./catalog.nix;
  appLib = import ./lib.nix { inherit catalog; };
  app = config.leenix.applications;

  isEnabled = x: ((app.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) appLib.all;

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
  config = lib.mkIf config.leenix.profiles.applications.enable {
    environment.systemPackages = packages;
  };
}
