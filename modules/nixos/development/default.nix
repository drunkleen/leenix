{ config, lib, pkgs, ... }:

# Package composition for the development catalog. Imported by
# profiles/development.nix. Only `environment.systemPackages` is touched:
# no services, daemons, drivers, firewall, database servers, or allowUnfree.
#
#   A leaves  -> enabled leaves add their Nix-owned packages
#   E leaves  -> enabled project-support leaves install the shared Nix-owned
#                generic runtime tooling (nodejs + pnpm); scaffolding metadata
#                is consumed by the home-side leenix-dev-scaffold helper.
#
# Dependencies (typescript->nodejs, kotlin/scala->jdk, vulkan->shader tools,
# ...) are implementation packages inside the leaf's `packages`; they never
# mutate another capability's policy boolean.
let
  catalog = import ./catalog.nix;
  devLib = import ./lib.nix { inherit catalog; };
  dev = config.leenix.development;

  isEnabled = x: ((dev.${x.cat} or { }).${x.leaf} or { }).enable or false;
  enabled = builtins.filter (x: isEnabled x) devLib.all;
  aEnabled = builtins.filter (x: x.meta.classification == "A") enabled;
  eEnabled = builtins.filter (x: x.meta.classification == "E") enabled;

  # Guarded leaves: defensive package selection — skip any package that is
  # missing from the pinned nixpkgs for this platform or is not available on it.
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

  # Native-library leaves (library/sdk/numerical-lib/gui-framework) also expose
  # their `.dev` outputs so pkg-config metadata + headers are discoverable via
  # the system profile (sw/lib/pkgconfig) — the Nix-native model, no global
  # CPATH/PKG_CONFIG_PATH hacks. Headers are referenced by the .pc files
  # directly. project-local devShells remain the reproducible path.
  devOutputKinds = [ "library" "sdk" "numerical-lib" "gui-framework" ];

  leafPkgs = x:
    let
      base = rawLeafPkgs x;
      devs = if builtins.elem x.meta.kind devOutputKinds then
        builtins.filter (p: p != null) (map (p: p.dev or null) base)
      else
        [ ];
    in
    base ++ devs;

  packages =
    builtins.concatLists (map leafPkgs aEnabled)
    ++ lib.optionals (eEnabled != [ ]) [ pkgs.nodejs pkgs.pnpm ];
in
{
  config = lib.mkIf config.leenix.profiles.development.enable {
    environment.systemPackages = packages;
  };
}
