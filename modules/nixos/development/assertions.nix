{ config, lib, ... }:

# Always-loaded assertions for the development catalog:
#   - profiles.development master gate (any enabled leaf with the profile off)
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

  profileGate = if (!config.leenix.profiles.development.enable) then (
    map (x: {
      assertion = false;
      message = "LEENIX ${devLib.path x} is enabled, but profiles.development is disabled. Enable profiles.development, or set ${devLib.path x} = false.";
    }) enabled
  ) else [ ];

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
