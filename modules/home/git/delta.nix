let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "ansi";

      palette = builtins.concatStringsSep ", " [
        "minus-style normal auto ${leenium.accent.red}"
        "minus-emph-style bold auto ${leenium.accent.red}"
        "minus-empty-line-marker-style normal auto ${leenium.accent.red}"
        "plus-style normal auto ${leenium.accent.emerald}"
        "plus-emph-style bold auto ${leenium.accent.emerald}"
        "plus-empty-line-marker-style normal auto ${leenium.accent.emerald}"
        "line-number normal auto ${leenium.neutral.muted}"
        "line-number-minus-style normal auto ${leenium.accent.red}"
        "line-number-plus-style normal auto ${leenium.accent.emerald}"
        "hunk-header-style bold auto ${leenium.accent.teal}"
        "hunk-header-file-style bold auto ${leenium.neutral.foreground}"
        "hunk-header-line-number-style normal auto ${leenium.neutral.muted}"
        "file-style bold auto ${leenium.neutral.foreground}"
        "file-decoration-style none"
        "zero-style syntax"
        "whitespace-error-style reverse auto ${leenium.accent.red}"
        "right-arrow-style normal auto ${leenium.accent.cyan}"
      ];
    };
  };
}
