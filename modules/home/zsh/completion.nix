{
  programs.zsh = {
    enableCompletion = true;

    completionInit = ''
      autoload -Uz compinit
      compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list \
        'm:{a-zA-Z}={A-Za-z}' \
        'r:|[._-]=* r:|=*' \
        'l:|=* r:|=*'

      zstyle ':completion:*' list-colors \
        "''${(s.:.)LS_COLORS}"

      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:descriptions' format \
        '%F{yellow}-- %d --%f'

      zstyle ':completion:*' use-cache true
      zstyle ':completion:*' cache-path \
        "$XDG_CACHE_HOME/zsh/completion-cache"
    '';
  };
}
