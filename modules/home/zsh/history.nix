{
  programs.zsh.history = {
    path = "$HOME/.local/share/zsh/history";
    size = 10000;
    save = 10000;
    ignoreDups = true;
    ignoreSpace = true;
    share = true;
  };
}
