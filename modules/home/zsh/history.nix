{
  programs.zsh = {
    history = {
      path = "$HOME/.local/share/zsh/history";
      size = 50000;
      save = 50000;

      ignoreDups = true;
      ignoreSpace = true;
      share = true;

      expireDuplicatesFirst = true;
      extended = true;
    };

    initContent = ''
      autoload -Uz up-line-or-beginning-search
      autoload -Uz down-line-or-beginning-search

      zle -N up-line-or-beginning-search
      zle -N down-line-or-beginning-search

      bindkey "^[[A" up-line-or-beginning-search
      bindkey "^[[B" down-line-or-beginning-search
    '';
  };
}
