{
  programs.zsh.shellAliases = {
    ls = "eza --icons=auto";
    l = "eza -1 --icons=auto";
    ll = "eza -l --icons=auto";
    la = "eza -la --icons=auto";
    lt = "eza --tree --icons=auto";

    cat = "bat";
    grep = "rg";
  };
}
