{ config, lib, ... }:

# Always-loaded assertions for the cybersecurity catalog:
#   - profiles.cybersecurity master gate
#   - unfree policy (never silently enabled)
#   - platform guards (fails only when an unsupported leaf is explicitly enabled)
let
  catalog = import ./catalog.nix;
  cybLib = import ./lib.nix { inherit catalog; };
  cyb = config.leenix.cybersecurity;
  arch = config.leenix.host.architecture;

  isEnabled = x: ((cyb.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) cybLib.all;
  onPlatform = x: builtins.elem arch x.meta.platforms;

  profileGate = if (!config.leenix.profiles.cybersecurity.enable) then (
    map (x: {
      assertion = false;
      message = "LEENIX ${cybLib.path x} is enabled, but profiles.cybersecurity is disabled. Enable profiles.cybersecurity, or set ${cybLib.path x} = false.";
    }) enabled
  ) else [ ];

  unfreeGate = map (x: {
    assertion = (config.nixpkgs.config.allowUnfree or false) == true;
    message = "LEENIX ${cybLib.path x} requires unfree packages; enable nixpkgs.config.allowUnfree or set ${cybLib.path x} = false.";
  }) (builtins.filter (x: x.meta.unfree) enabled);

  platformGate = map (x: {
    assertion = onPlatform x;
    message = "LEENIX ${cybLib.path x} is not available on ${arch}; disable it or choose a supported architecture.";
  }) (builtins.filter (x: !onPlatform x) enabled);
in
{
  assertions = profileGate ++ unfreeGate ++ platformGate;
}
