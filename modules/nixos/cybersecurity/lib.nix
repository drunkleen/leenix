# Shared iteration helpers over the canonical cybersecurity catalog.
{ catalog }:
let
  cats = builtins.attrNames catalog;
  leavesOf = cat: builtins.attrNames catalog.${cat};
  all = builtins.concatLists (map (cat: map (leaf: {
    inherit cat leaf;
    meta = catalog.${cat}.${leaf};
  }) (leavesOf cat)) cats);
  path = x: "cybersecurity.${x.cat}.${x.leaf}";
in
{
  inherit cats leavesOf all path;
}
