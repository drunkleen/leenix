# Generic collision-safe merge of host-variable section attrsets.
#
# LEENIX host policy is split by responsibility into variables.nix/*.nix
# and composed by the host's variables.nix entrypoint. This helper merges those
# section attrsets into ONE effective host-policy attrset, refusing to silently
# overwrite a top-level key defined by two different sections.
#
# `sections` is a list of attrsets:
#   { file  = "variables/networking.nix";  # for actionable error messages
#     value = { ... };                     # the section's top-level attrs
#   }
#
# On a duplicate top-level key it fails evaluation with a message naming both
# sections, e.g.:
#   LEENIX host variable collision:
#   top-level key `networking` is defined by both
#   variables/networking.nix and variables/services.nix
#
# Pure `builtins` on purpose: it is imported from host variables.nix files that
# receive no arguments (see lib/mkHost.nix `import "${hostPath}/variables.nix"`),
# so it must not depend on a Nixpkgs `lib` being threaded through.
sections:
let
  step = acc: section:
    let
      names = builtins.attrNames section.value;
      dupes = builtins.filter (n: builtins.hasAttr n acc.merged) names;
    in
    if dupes != [ ] then
      throw ''
        LEENIX host variable collision:
        top-level key `${builtins.head dupes}` is defined by both
        `${acc.origin.${builtins.head dupes}}` and `${section.file}`
      ''
    else {
      merged = acc.merged // section.value;
      origin =
        acc.origin
        // builtins.listToAttrs (map (n: {
          name = n;
          value = section.file;
        }) names);
    };
in
(builtins.foldl' step {
  merged = { };
  origin = { };
} sections).merged
