let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.fzf.colors = {
    bg = leenium.background.main;
    fg = leenium.neutral.foreground;
    "bg+" = leenium.background.active;
    "fg+" = leenium.neutral.bright;
    hl = leenium.accent.cyan;
    "hl+" = leenium.accent.cyan;
    info = leenium.neutral.muted;
    border = leenium.neutral.border;
    prompt = leenium.accent.teal;
    pointer = leenium.accent.cyan;
    marker = leenium.accent.emerald;
    spinner = leenium.accent.teal;
    header = leenium.neutral.secondary;
    "preview-bg" = leenium.background.panel;
    "preview-fg" = leenium.neutral.foreground;
    "preview-border" = leenium.neutral.border;
  };
}
