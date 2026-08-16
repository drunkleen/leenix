{ lib, ... }:

# Derived consistency checks for the canonical development catalog. All counts
# and sets are DERIVED from catalog.nix and compared against frozen constants,
# so drift fails evaluation instead of silently changing behavior.
let
  catalog = import ./catalog.nix;
  devLib = import ./lib.nix { inherit catalog; };

  aLeaves = builtins.filter (x: x.meta.classification == "A") devLib.all;
  eLeaves = builtins.filter (x: x.meta.classification == "E") devLib.all;
  unfreeLeaves = builtins.filter (x: x.meta.unfree) devLib.all;
  guardedLeaves = builtins.filter (x: x.meta.guarded) devLib.all;
  heavyLeaves = builtins.filter (x: x.meta.heavy) devLib.all;

  sortedOk = xs: xs == builtins.sort builtins.lessThan xs;
  catOrderOk = sortedOk devLib.cats;
  leafOrderOk = builtins.all (cat: sortedOk (devLib.leavesOf cat)) devLib.cats;

  # exactly one of packages/support
  oneOfOk = builtins.all (x: (builtins.hasAttr "packages" x.meta) != (builtins.hasAttr "support" x.meta)) devLib.all;
  # classification only A/E
  classOk = builtins.all (x: x.meta.classification == "A" || x.meta.classification == "E") devLib.all;
  # A leaves have a package function
  aPackagesOk = builtins.all (x: builtins.isFunction x.meta.packages) aLeaves;
  # E leaves have a non-empty support implementation (runtime + scaffold)
  eSupportOk = builtins.all (x: (x.meta.support.scaffold or null) != null && (x.meta.support.runtime or [ ]) != [ ]) eLeaves;

  frozenUnfree = [
    "development.cloud.terraform"
    "development.compute.cuda"
    "development.databases.mongodb"
    "development.mobile.android"
  ];
  frozenGuarded = [
    "development.compute.cuda"
    "development.compute.rocm"
    "development.languages.swift"
    "development.mobile.android"
  ];

  checks = [
    { name = "category count == 24"; ok = builtins.length devLib.cats == 24; }
    { name = "leaf count == 198"; ok = builtins.length devLib.all == 198; }
    { name = "A classification count == 188"; ok = builtins.length aLeaves == 188; }
    { name = "E classification count == 10"; ok = builtins.length eLeaves == 10; }
    { name = "categories alphabetically ordered"; ok = catOrderOk; }
    { name = "leaves alphabetically ordered per category"; ok = leafOrderOk; }
    { name = "exactly one of packages/support per leaf"; ok = oneOfOk; }
    { name = "classification is only A or E"; ok = classOk; }
    { name = "every A leaf has a package implementation"; ok = aPackagesOk; }
    { name = "every E leaf has a non-empty support implementation"; ok = eSupportOk; }
    { name = "unfree set matches the 4 frozen leaves"; ok = builtins.sort builtins.lessThan (map devLib.path unfreeLeaves) == frozenUnfree; }
    { name = "guarded set matches the 4 frozen leaves"; ok = builtins.sort builtins.lessThan (map devLib.path guardedLeaves) == frozenGuarded; }
    { name = "heavy count matches frozen catalog"; ok = builtins.length heavyLeaves == 17; }
  ];
in
{
  assertions = map (c: {
    assertion = c.ok;
    message = "LEENIX development catalog check failed: ${c.name} (derived from catalog.nix).";
  }) (builtins.filter (c: !c.ok) checks);
}
