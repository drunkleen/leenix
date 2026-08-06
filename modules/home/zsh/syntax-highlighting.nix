let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.zsh.syntaxHighlighting = {
    enable = true;

    highlighters = [
      "main"
      "brackets"
    ];

    styles = {
      default = "fg=${leenium.neutral.foreground}";
      unknown-token = "fg=${leenium.accent.red},bold";
      reserved-word = "fg=${leenium.accent.blue},bold";
      alias = "fg=${leenium.accent.cyan},bold";
      suffix-alias = "fg=${leenium.accent.cyan}";
      global-alias = "fg=${leenium.accent.cyan}";
      builtin = "fg=${leenium.accent.teal},bold";
      function = "fg=${leenium.accent.teal}";
      command = "fg=${leenium.accent.teal},bold";
      precommand = "fg=${leenium.accent.teal}";
      commandseparator = "fg=${leenium.accent.yellow}";
      hashed-command = "fg=${leenium.accent.teal}";
      assign = "fg=${leenium.neutral.foreground}";
      redirection = "fg=${leenium.accent.yellow}";
      comment = "fg=${leenium.neutral.muted}";
      named-fd = "fg=${leenium.neutral.secondary}";
      numeric-fd = "fg=${leenium.neutral.secondary}";
      path = "fg=${leenium.accent.cyan},underline";
      path_pathseparator = "fg=${leenium.accent.cyan}";
      globbing = "fg=${leenium.accent.cyan},bold";
      history-expansion = "fg=${leenium.accent.blue}";
      arithmetic-expansion = "fg=${leenium.accent.blue}";
      single-hyphen-option = "fg=${leenium.neutral.secondary}";
      double-hyphen-option = "fg=${leenium.neutral.secondary}";
      back-quoted-argument = "fg=${leenium.accent.yellow}";
      back-quoted-argument-delimiter = "fg=${leenium.accent.yellow},bold";
      single-quoted-argument = "fg=${leenium.accent.emerald}";
      single-quoted-argument-unclosed = "fg=${leenium.accent.red},bold";
      double-quoted-argument = "fg=${leenium.accent.emerald}";
      double-quoted-argument-unclosed = "fg=${leenium.accent.red},bold";
      dollar-quoted-argument = "fg=${leenium.accent.emerald}";
      dollar-quoted-argument-unclosed = "fg=${leenium.accent.red},bold";
      rc-quote = "fg=${leenium.accent.emerald}";
      dollar-double-quoted-argument = "fg=${leenium.accent.cyan}";
      back-double-quoted-argument = "fg=${leenium.accent.yellow}";
      command-substitution = "fg=${leenium.accent.cyan}";
      command-substitution-delimiter = "fg=${leenium.accent.cyan},bold";
      process-substitution = "fg=${leenium.accent.cyan}";
      process-substitution-delimiter = "fg=${leenium.accent.cyan},bold";
      bracket-level-1 = "fg=${leenium.accent.teal},bold";
      bracket-level-2 = "fg=${leenium.accent.cyan},bold";
      bracket-level-3 = "fg=${leenium.accent.blue},bold";
      bracket-level-4 = "fg=${leenium.accent.yellow},bold";
      cursor-matchingbracket = "fg=${leenium.neutral.bright},bold,underline";
    };
  };
}
