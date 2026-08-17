{ lib, ... }:

# LEENIX tmux — Omarchy theme structure with LEENIUM colors.
#
# STYLE/LAYOUT = Omarchy (quattro) exactly: same status structure, spacing,
# session badge, window formats, right-state labels, pane-border behavior,
# message/mode/clock styles.
# COLORS = LEENIUM (canonical palette from lib/leenium.nix).
#
# Semantic mapping (Omarchy -> LEENIUM):
#   blue       -> accent   #33B8A8
#   brightblack-> muted    #718688
#   black      -> bg       #0B1113   (fg on the accent badge / mode)
#   default bg/fg preserved as "default" (transparent over the terminal, which
#   is LEENIUM bg #0b1113 / text #d8e3e0) — preserves Omarchy's exact
#   terminal-background semantics.
let
  leenium = import ../../../../lib/leenium.nix;
  accent = lib.toLower leenium.defs.accent;      # #33b8a8
  muted = lib.toLower leenium.defs.muted;        # #718688
  bg = lib.toLower leenium.defs.bg;              # #0b1113
in
{
  text = ''
    set -g status-style "bg=default,fg=default"
    set -g status-left "#[fg=${bg},bg=${accent},bold] #S #[bg=default] "
    set -g status-right "#[fg=${accent}]#{?pane_in_mode,COPY ,}#{?client_prefix,PREFIX ,}#{?window_zoomed_flag,ZOOM ,}#[fg=${muted}]#h "
    set -g window-status-format "#[fg=${muted}] #I:#W "
    set -g window-status-current-format "#[fg=${accent},bold] #I:#W "
    set -g pane-border-style "fg=${muted}"
    set -g pane-active-border-style "fg=${accent}"
    set -g message-style "bg=default,fg=${accent}"
    set -g message-command-style "bg=default,fg=${accent}"
    set -g mode-style "bg=${accent},fg=${bg}"
    setw -g clock-mode-colour "${accent}"
  '';
}
