{ lib, ... }:

# Derived consistency checks for the cybersecurity catalog. All counts and sets
# are DERIVED from catalog.nix and compared against frozen constants so drift
# fails evaluation.
let
  catalog = import ./catalog.nix;
  cybLib = import ./lib.nix { inherit catalog; };

  aLeaves = builtins.filter (x: x.meta.classification == "A") cybLib.all;
  eLeaves = builtins.filter (x: x.meta.classification == "E") cybLib.all;
  unfreeLeaves = builtins.filter (x: x.meta.unfree) cybLib.all;
  heavyLeaves = builtins.filter (x: x.meta.heavy) cybLib.all;
  wordlistLeaves = builtins.filter (x: x.meta.kind == "wordlist") cybLib.all;

  sortedOk = xs: xs == builtins.sort builtins.lessThan xs;
  catOrderOk = sortedOk cybLib.cats;
  leafOrderOk = builtins.all (cat: sortedOk (cybLib.leavesOf cat)) cybLib.cats;

  # A leaves have a package function; E leaves have a non-empty integration.
  aPackagesOk = builtins.all (x: builtins.isFunction x.meta.packages) aLeaves;
  eIntegrationOk = builtins.all (x: (x.meta.integration or null) != null
    && (x.meta.integration.exe or "") != ""
    && (x.meta.integration.setup or "") != "") eLeaves;
  # exactly one of packages / integration per leaf
  oneOfOk = builtins.all (x: (builtins.hasAttr "packages" x.meta) != (builtins.hasAttr "integration" x.meta)) cybLib.all;
  # wordlist leaves carry packages + resourcePath + linkPath
  wordlistOk = builtins.all (x: builtins.isFunction x.meta.packages
    && (x.meta.resourcePath or "") != "" && (x.meta.linkPath or "") != "") wordlistLeaves;

  frozenUnfree = [
    "cybersecurity.forensics.volatility3"
    "cybersecurity.proxy.burpsuiteCommunity"
  ];

  checks = [
    { name = "category count == 19"; ok = builtins.length cybLib.cats == 19; }
    { name = "leaf count == 115"; ok = builtins.length cybLib.all == 115; }
    { name = "A classification count == 110"; ok = builtins.length aLeaves == 110; }
    { name = "E classification count == 5"; ok = builtins.length eLeaves == 5; }
    { name = "categories alphabetically ordered"; ok = catOrderOk; }
    { name = "leaves alphabetically ordered per category"; ok = leafOrderOk; }
    { name = "classification is only A or E"; ok = builtins.all (x: x.meta.classification == "A" || x.meta.classification == "E") cybLib.all; }
    { name = "exactly one of packages/integration per leaf"; ok = oneOfOk; }
    { name = "every A leaf has a package implementation"; ok = aPackagesOk; }
    { name = "every E leaf has a non-empty integration implementation"; ok = eIntegrationOk; }
    { name = "every wordlist leaf has packages + resourcePath"; ok = wordlistOk; }
    { name = "unfree set matches audited result (burpsuiteCommunity, volatility3)"; ok = builtins.sort builtins.lessThan (map cybLib.path unfreeLeaves) == frozenUnfree; }
    { name = "heavy count matches frozen catalog"; ok = builtins.length heavyLeaves == 10; }
  ];
in
{
  assertions = map (c: {
    assertion = c.ok;
    message = "LEENIX cybersecurity catalog check failed: ${c.name} (derived from catalog.nix).";
  }) (builtins.filter (c: !c.ok) checks);
}
