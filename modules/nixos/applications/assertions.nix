{ config, lib, ... }:

# Always-loaded assertions for the applications catalog:
#   - profiles.applications master gate
#   - unfree policy (never silently enabled)
#   - platform guards (fails only when an unsupported leaf is explicitly enabled)
let
  catalog = import ./catalog.nix;
  appLib = import ./lib.nix { inherit catalog; };
  app = config.leenix.applications;
  arch = config.leenix.host.architecture;

  isEnabled = x: ((app.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) appLib.all;
  onPlatform = x: builtins.elem arch x.meta.platforms;

  profileGate = if (!config.leenix.profiles.applications.enable) then (
    map (x: {
      assertion = false;
      message = "LEENIX ${appLib.path x} is enabled, but profiles.applications is disabled. Enable profiles.applications, or set ${appLib.path x} = false.";
    }) enabled
  ) else [ ];

  unfreeGate = map (x: {
    assertion = (config.nixpkgs.config.allowUnfree or false) == true;
    message = "LEENIX ${appLib.path x} requires unfree package(s); enable nixpkgs.config.allowUnfree or set ${appLib.path x} = false.";
  }) (builtins.filter (x: x.meta.unfree) enabled);

  platformGate = map (x: {
    assertion = onPlatform x;
    message = "LEENIX ${appLib.path x} is not available on ${arch}; disable it or choose a supported architecture.";
  }) (builtins.filter (x: !onPlatform x) enabled);
in
{
  assertions = profileGate ++ unfreeGate ++ platformGate;
}
