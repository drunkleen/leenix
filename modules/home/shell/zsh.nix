{ pkgs, lib, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    initContent = lib.mkOrder 1000 ''
      bindkey -e

      bindkey '^?' backward-delete-char
      bindkey '^H' backward-delete-char

      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      bindkey '^[[3~' delete-char

      bindkey '^[[5~' up-line-or-history
      bindkey '^[[6~' down-line-or-history

      bindkey '^[[1;5H' beginning-of-line
      bindkey '^[[1;5F' end-of-line

      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}'
      '';

    autosuggestion = {
      enable = true;
    };

    syntaxHighlighting = {
      enable = true;
    };

    plugins = [
      {
        name = "fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab";
      }
      {
        name = "zsh-fzf-history-search";
        src = "${pkgs.zsh-fzf-history-search}/share/zsh-fzf-history-search";
      }
    ];

    history = {
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    package = pkgs.zsh;
  };

  home.packages = with pkgs; [
    unzip
  ];
}
