# LEENIUM AI theme palette — canonical source for AI-application theming.
#
# AI-scoped: this palette is NOT the global LEENIX theme. It owns the exact
# LEENIUM defs + semantic mappings (OpenCode theme schema) so generated theme
# artifacts (e.g. ~/.config/opencode/themes/leenium.json) are reproducible and
# byte/semantically faithful. Other LEENIX consumers (Waybar, Neovim, Limine,
# Plymouth, GTK/Qt, Hyprland, Rofi, Mako, Kitty, SwayOSD) are NOT changed.
{
  defs = {
    bg = "#0B1113";
    sidebar = "#0E1518";
    panel = "#11191C";
    card = "#141E21";
    popup = "#182326";
    floating = "#1D2A2D";
    hover = "#223033";
    active = "#304144";
    selection = "#365156";
    text = "#D8E3E0";
    muted = "#718688";
    accent = "#33B8A8";
    cyan = "#59D6C5";
    sea = "#4DBA7A";
    seaBright = "#67CF94";
    type = "#71E4D8";
    warn = "#D9C76B";
    warnBright = "#EFD45E";
    orange = "#F4A259";
    error = "#E16F73";
    errorSoft = "#F08787";
    blue = "#5E9BFF";
  };

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
