{
  programs.zsh.initContent = ''
    bindkey -e

    setopt AUTO_CD
    setopt CORRECT
    setopt HIST_IGNORE_ALL_DUPS
    setopt SHARE_HISTORY
  '';
}
