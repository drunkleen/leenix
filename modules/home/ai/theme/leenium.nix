# LEENIUM AI theme — semantic mappings for AI-application theming.
#
# The canonical LEENIUM color palette lives in lib/leenium.nix (single shared
# source); this module re-exports `defs` from it and adds the OpenCode theme
# semantic mappings so generated artifacts (e.g.
# ~/.config/opencode/themes/leenium.json) stay reproducible and faithful.

{
  defs = (import ../../../../lib/leenium.nix).defs;

  theme = {
    primary = { dark = "accent"; light = "accent"; };
    secondary = { dark = "cyan"; light = "cyan"; };
    accent = { dark = "blue"; light = "blue"; };
    error = { dark = "error"; light = "error"; };
    warning = { dark = "warn"; light = "warn"; };
    success = { dark = "sea"; light = "sea"; };
    info = { dark = "blue"; light = "blue"; };
    text = { dark = "text"; light = "text"; };
    textMuted = { dark = "muted"; light = "muted"; };
    background = { dark = "bg"; light = "bg"; };
    backgroundPanel = { dark = "panel"; light = "panel"; };
    backgroundElement = { dark = "card"; light = "card"; };
    border = { dark = "hover"; light = "hover"; };
    borderActive = { dark = "active"; light = "active"; };
    borderSubtle = { dark = "hover"; light = "hover"; };
    diffAdded = { dark = "sea"; light = "sea"; };
    diffRemoved = { dark = "error"; light = "error"; };
    diffContext = { dark = "muted"; light = "muted"; };
    diffHunkHeader = { dark = "accent"; light = "accent"; };
    diffHighlightAdded = { dark = "seaBright"; light = "seaBright"; };
    diffHighlightRemoved = { dark = "errorSoft"; light = "errorSoft"; };
    diffAddedBg = { dark = "floating"; light = "floating"; };
    diffRemovedBg = { dark = "floating"; light = "floating"; };
    diffContextBg = { dark = "panel"; light = "panel"; };
    diffLineNumber = { dark = "muted"; light = "muted"; };
    diffAddedLineNumberBg = { dark = "floating"; light = "floating"; };
    diffRemovedLineNumberBg = { dark = "floating"; light = "floating"; };
    markdownText = { dark = "text"; light = "text"; };
    markdownHeading = { dark = "blue"; light = "blue"; };
    markdownLink = { dark = "cyan"; light = "cyan"; };
    markdownLinkText = { dark = "accent"; light = "accent"; };
    markdownCode = { dark = "seaBright"; light = "seaBright"; };
    markdownBlockQuote = { dark = "muted"; light = "muted"; };
    markdownEmph = { dark = "orange"; light = "orange"; };
    markdownStrong = { dark = "warn"; light = "warn"; };
    markdownHorizontalRule = { dark = "hover"; light = "hover"; };
    markdownListItem = { dark = "cyan"; light = "cyan"; };
    markdownListEnumeration = { dark = "accent"; light = "accent"; };
    markdownImage = { dark = "blue"; light = "blue"; };
    markdownImageText = { dark = "cyan"; light = "cyan"; };
    markdownCodeBlock = { dark = "text"; light = "text"; };
    syntaxComment = { dark = "muted"; light = "muted"; };
    syntaxKeyword = { dark = "accent"; light = "accent"; };
    syntaxFunction = { dark = "errorSoft"; light = "errorSoft"; };
    syntaxVariable = { dark = "text"; light = "text"; };
    syntaxString = { dark = "seaBright"; light = "seaBright"; };
    syntaxNumber = { dark = "warn"; light = "warn"; };
    syntaxType = { dark = "type"; light = "type"; };
    syntaxOperator = { dark = "muted"; light = "muted"; };
    syntaxPunctuation = { dark = "muted"; light = "muted"; };
  };
}
