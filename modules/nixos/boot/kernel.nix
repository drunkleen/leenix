{
  config,
  lib,
  pkgs,
  ...
}:

# LEENIX declarative kernel policy.
#
#   leenix.boot.kernel.channel ∈ { default, stable, latest, version }
#
#   default  → LEENIX assigns NO boot.kernelPackages. Whatever NixOS or a
#              specialized hardware module owns stays in charge (ownership
#              escape hatch; mkForce stays exceptional).
#   stable   → pkgs.linuxPackages (the nixpkgs default/stable set).
#   latest   → pkgs.linuxPackages_latest (latest suitable kernel in the pin).
#   version  → a specific kernel series (e.g. "6.18") selected from the
#              PINNED nixpkgs, never kernel.org directly.
#
# The selectable series inventory is DERIVED from the pinned nixpkgs at eval
# time: plain `linux_<major>_<minor>` package-set attrs only, with EOL throw
# stubs filtered via tryEval. Variants (hardened/rt/zen/xanmod/lqx/libre/rpi)
# and RC kernels (linux_testing) are never exposed.

let
  cfg = config.leenix.boot.kernel;
  kp = pkgs.linuxKernel.packages;

  # Plain versioned series attrs only; EOL stubs (`throw`) drop out via tryEval.
  plainSeries = builtins.filter
    (n:
      builtins.match "^linux_[0-9]+_[0-9]+$" n != null
      && (builtins.tryEval kp.${n}).success)
    (builtins.attrNames kp);

  # "linux_6_18" -> "6.18"
  availableSeries = map
    (a: builtins.replaceStrings [ "_" ] [ "." ] (builtins.substring 6 99 a))
    plainSeries;

  patchForm = v: builtins.match "^[0-9]+\.[0-9]+\.[0-9]+$" v != null;
  seriesAttr = v: "linux_" + builtins.replaceStrings [ "." ] [ "_" ] v;

  # Evaluated lazily, left to right: never touches a null / patch-form /
  # unavailable version. Prevents raw Nix errors before the LEENIX assertions.
  validSeries =
    cfg.version != null
    && !patchForm cfg.version
    && builtins.elem cfg.version availableSeries;

  # The versioned attr is only forced when validSeries is true.
  selected =
    if cfg.channel == "stable" then pkgs.linuxPackages
    else if cfg.channel == "latest" then pkgs.linuxPackages_latest
    else if cfg.channel == "version" && validSeries then kp.${seriesAttr cfg.version}
    else null;

  # LEENIX assigns boot.kernelPackages ONLY for a valid, owned selection.
  ownsKernel =
    cfg.channel == "stable"
    || cfg.channel == "latest"
    || (cfg.channel == "version" && validSeries);

  displayVersion = if cfg.version != null then cfg.version else "<null>";
  seriesHint = if cfg.version != null
    then lib.concatStringsSep "." (lib.take 2 (lib.splitString "." cfg.version))
    else "";

  assertions = [
    {
      assertion = cfg.channel != "version" || cfg.version != null;
      message = "LEENIX kernel channel is \"version\" but no series was set. Set leenix.boot.kernel.version, e.g. \"6.18\".";
    }
    {
      assertion = cfg.channel == "version" || cfg.version == null;
      message = "LEENIX kernel version \"${displayVersion}\" is set but channel is \"${cfg.channel}\". version is only used with channel = \"version\".";
    }
    {
      # Exact patch input (e.g. "6.18.42") fires ONLY this dedicated hint.
      assertion = cfg.channel != "version" || cfg.version == null || !patchForm cfg.version;
      message = "LEENIX kernel version \"${displayVersion}\" is an exact patch version. Use the kernel series \"${seriesHint}\"; nixpkgs controls the selected patch release.";
    }
    {
      # Patch-form input passes here (dedicated assertion above); only truly
      # unavailable series reach this message.
      assertion = cfg.channel != "version" || cfg.version == null || patchForm cfg.version || validSeries;
      message = ''LEENIX kernel version "${displayVersion}" is not available in the current nixpkgs pin.
Available LEENIX-selectable kernel series:
${lib.concatStringsSep ", " availableSeries}'';
    }
  ];
in
{
  config = lib.mkMerge [
    { inherit assertions; }

    # channel = "default" → contributes ZERO boot.kernelPackages definitions.
    (lib.mkIf ownsKernel {
      boot.kernelPackages = selected;
    })
  ];
}
