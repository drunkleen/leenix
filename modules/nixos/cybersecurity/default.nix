{ config, lib, pkgs, ... }:

# Package composition for the cybersecurity catalog. Imported by
# profiles/cybersecurity.nix. Only `environment.systemPackages` is touched:
# no services, daemons, firewall, network, SSH, driver, database or
# container-daemon policy, and no auto-scanning/exploitation behavior.
#
#   A leaves (kind != wordlist) -> enabled leaves add their Nix-owned packages
#   wordlist leaves             -> install the dataset (data only; no auto-use)
#   E leaves                    -> no package; real integration launchers live
#                                  in the home cybersecurity script group
# Library-kind leaves also expose `.dev` outputs for headers/pkg-config.
let
  catalog = import ./catalog.nix;
  cybLib = import ./lib.nix { inherit catalog; };
  cyb = config.leenix.cybersecurity;

  isEnabled = x: ((cyb.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) cybLib.all;
  aEnabled = builtins.filter (x: x.meta.classification == "A") enabled;

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

  # Expose .dev outputs for library-kind leaves (headers/pkg-config discovery).
  devOutputKinds = [ "library" ];

  leafPkgs = x:
    let
      base = rawLeafPkgs x;
      devs = if builtins.elem x.meta.kind devOutputKinds then
        builtins.filter (p: p != null) (map (p: p.dev or null) base)
      else
        [ ];
    in
    base ++ devs;

  packages = builtins.concatLists (map leafPkgs aEnabled);

  # Wordlist datasets: NixOS's system-path buildEnv only links `pathsToLink`
  # subdirs, so generic `share/*` data is not exposed by default. Extend
  # environment.pathsToLink (data exposure only) so enabled wordlist resources
  # are discoverable at their canonical /run/current-system/sw paths.
  wordlistLeaves = builtins.filter (x: x.meta.kind == "wordlist") aEnabled;
  linkPaths = lib.unique (map (x: x.meta.linkPath) wordlistLeaves);
in
{
  config = lib.mkIf config.leenix.profiles.cybersecurity.enable {
    environment.systemPackages = packages;
    environment.pathsToLink = linkPaths;
  };
}
