{ lib, ... }:

# Derived consistency checks for the AI catalog. All counts and sets are DERIVED
# from catalog.nix and compared against frozen constants so drift fails eval.
let
  catalog = import ./catalog.nix;
  aiLib = import ./lib.nix { inherit catalog; };

  aLeaves = builtins.filter (x: x.meta.classification == "A") aiLib.all;
  unfreeLeaves = builtins.filter (x: x.meta.unfree) aiLib.all;
  runtimeHeavyLeaves = builtins.filter (x: x.meta.runtimeHeavy) aiLib.all;

  sortedOk = xs: xs == builtins.sort builtins.lessThan xs;
  catOrderOk = sortedOk aiLib.cats;
  leafOrderOk = builtins.all (cat: sortedOk (aiLib.leavesOf cat)) aiLib.cats;

  # A leaves have a package function; every leaf has required metadata.
  aPackagesOk = builtins.all (x: builtins.isFunction x.meta.packages) aLeaves;
  metaOk = builtins.all (x: (x.meta.description or "") != ""
    && (x.meta.kind or "") != ""
    && (x.meta.themeSupport or "") != ""
    && (x.meta.autoUpdatePolicy or "") != "") aiLib.all;

  frozenUnfree = [
    "ai.codingAgents.claudeCode"
    "ai.localRuntimes.lmstudio"
  ];

  checks = [
    { name = "category count == 4"; ok = builtins.length aiLib.cats == 4; }
    { name = "leaf count == 16"; ok = builtins.length aiLib.all == 16; }
    { name = "A classification count == 16"; ok = builtins.length aLeaves == 16; }
    { name = "categories alphabetically ordered"; ok = catOrderOk; }
    { name = "leaves alphabetically ordered per category"; ok = leafOrderOk; }
    { name = "classification is only A"; ok = builtins.all (x: x.meta.classification == "A") aiLib.all; }
    { name = "every A leaf has a package implementation"; ok = aPackagesOk; }
    { name = "every leaf has complete metadata"; ok = metaOk; }
    { name = "unfree set matches audited result (claudeCode, lmstudio)"; ok = builtins.sort builtins.lessThan (map aiLib.path unfreeLeaves) == frozenUnfree; }
    { name = "localRuntimes carry runtimeHeavy"; ok = builtins.all (x: x.meta.runtimeHeavy) (builtins.filter (x: x.cat == "localRuntimes") aiLib.all); }
  ];
in
{
  assertions = map (c: {
    assertion = c.ok;
    message = "LEENIX AI catalog check failed: ${c.name} (derived from catalog.nix).";
  }) (builtins.filter (c: !c.ok) checks);
}
