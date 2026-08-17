{ config, lib, ... }:

# Always-loaded assertions for the development catalog:
#   - per-category profile gate (editors/ides allowed by desktop OR development;
#     all other categories still require profiles.development)
#   - unfree policy (never silently allowed; never mutates allowUnfree)
#   - platform guards (fails only when an unsupported leaf is explicitly enabled)
let
  catalog = import ./catalog.nix;
  devLib = import ./lib.nix { inherit catalog; };
  dev = config.leenix.development;
  arch = config.leenix.host.architecture;

  isEnabled = x: ((dev.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) devLib.all;
  onPlatform = x: builtins.elem arch x.meta.platforms;

  # editors/ides are desktop-capable categories: permitted by the desktop OR the
  # development profile. Every other category requires profiles.development.
  leafAllowed = x:
    if builtins.elem x.cat [ "editors" "ides" ]
    then (config.leenix.profiles.desktop.enable || config.leenix.profiles.development.enable)
    else config.leenix.profiles.development.enable;

  profileGate = map (x: {
    assertion = leafAllowed x;
    message = "LEENIX ${devLib.path x} is enabled, but neither profiles.desktop nor profiles.development is enabled for this ${x.cat} capability. Enable the relevant profile, or set ${devLib.path x} = false.";
  }) enabled;

  unfreeGate = map (x: {
    assertion = (config.nixpkgs.config.allowUnfree or false) == true;
    message = "LEENIX ${devLib.path x} requires unfree packages; enable nixpkgs.config.allowUnfree or set ${devLib.path x} = false.";
  }) (builtins.filter (x: x.meta.unfree) enabled);

  platformGate = map (x: {
    assertion = onPlatform x;
    message = "LEENIX ${devLib.path x} is not available on ${arch}; disable it or choose a supported architecture.";
  }) (builtins.filter (x: !onPlatform x) enabled);
in
{
  assertions = profileGate ++ unfreeGate ++ platformGate;
}
