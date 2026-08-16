{ config, lib, ... }:

# Always-loaded assertions for the AI catalog:
#   - profiles.ai master gate
#   - unfree policy (never silently enabled)
#   - platform guards (fails only when an unsupported leaf is explicitly enabled)
let
  catalog = import ./catalog.nix;
  aiLib = import ./lib.nix { inherit catalog; };
  ai = config.leenix.ai;
  arch = config.leenix.host.architecture;

  isEnabled = x: ((ai.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) aiLib.all;
  onPlatform = x: builtins.elem arch x.meta.platforms;

  profileGate = if (!config.leenix.profiles.ai.enable) then (
    map (x: {
      assertion = false;
      message = "LEENIX ${aiLib.path x} is enabled, but profiles.ai is disabled. Enable profiles.ai, or set ${aiLib.path x} = false.";
    }) enabled
  ) else [ ];

  unfreeGate = map (x: {
    assertion = (config.nixpkgs.config.allowUnfree or false) == true;
    message = "LEENIX ${aiLib.path x} requires unfree package(s); enable nixpkgs.config.allowUnfree or set ${aiLib.path x} = false.";
  }) (builtins.filter (x: x.meta.unfree) enabled);

  platformGate = map (x: {
    assertion = onPlatform x;
    message = "LEENIX ${aiLib.path x} is not available on ${arch}; disable it or choose a supported architecture.";
  }) (builtins.filter (x: !onPlatform x) enabled);
in
{
  assertions = profileGate ++ unfreeGate ++ platformGate;
}
