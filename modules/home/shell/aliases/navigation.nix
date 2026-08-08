{ ... }:

{
  programs.zsh.shellAliases = {
    cat = "bat";

    ls = "eza --icons=auto";
    ll = "eza --icons=auto -lah";
    la = "eza --icons=auto -A";
    l = "eza --icons=auto -CF";

    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    c = "clear";
  };
}
