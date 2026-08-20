{ lib, leenix, ... }:

# Home AI configuration ownership (non-secret only).
#
# Binary/package ownership lives in the NixOS AI catalog
# (modules/nixos/ai). This module owns:
#   - OpenCode: generated LEENIUM theme + config (theme = "leenium",
#     autoupdate = false) using the exact documented schema.
#   - Codex: documented non-secret config (auto_update = false).
#
# Authentication / OAuth / sessions / caches / models remain mutable user/runtime
# state. No secrets are ever stored here.
let
  aiPol = leenix.ai;
  enabled = cat: leaf: aiPol.${cat}.${leaf}.enable;
  leenium = import ./theme/leenium.nix;
in
{
  home.file = lib.mkMerge [
    (lib.mkIf (enabled "codingAgents" "opencode") {
      ".config/opencode/themes/leenium.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/theme.json";
        inherit (leenium) defs theme;
      };
      # OpenCode config: select the LEENIUM theme and disable the self-updater
      # so Nix remains the binary owner.
      ".config/opencode/opencode.json".text = builtins.toJSON {
        theme = "leenium";
        autoupdate = false;
      };
    })
    (lib.mkIf (enabled "codingAgents" "codex") {
      # Codex documented non-secret config; ~/.codex/auth.json stays user-owned.
      ".codex/config.toml".text = ''
        # Managed by LEENIX (Home Manager). Auto-update disabled so Nix owns the binary.
        auto_update = false
      '';
    })
  ];
}
