{ lib, ... }:

# Canonical LEENIX tmux configuration — a faithful Omarchy (quattro) port with
# LEENIUM colors. Shared across all hosts. The tmux binary is guaranteed by
# NixOS base (profiles/base.nix); Home Manager owns only this configuration,
# so package = null avoids duplicate ownership.
#
# The full config is emitted by Home Manager to ~/.config/tmux/tmux.conf
# (programs.tmux), so Omarchy's `prefix+q` reload semantics
# (source-file ~/.config/tmux/tmux.conf) remain valid against the Nix-owned
# generated file.
let
  tmuxConfig = import ./config.nix { inherit lib; };
  tmuxTheme = import ./theme.nix { inherit lib; };
in
{
  programs.tmux = {
    enable = true;
    package = null;
    # Structured options mirror Omarchy/tmux defaults so the Home Manager
    # prelude never contradicts the ported extraConfig below. The complete
    # Omarchy config is in extraConfig (config.nix + theme.nix).
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 50000;
    terminal = "tmux-256color";
    extraConfig = ''
      ${tmuxConfig.text}
      ${tmuxTheme.text}
    '';
  };
}
