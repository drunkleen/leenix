{ ... }:

{
  programs.zsh.shellAliases = {
    c = "clear";
    cls = "clear";

    lz = "ls";
    ls = "eza -a --icons=auto";
    l = "eza -lh --icons=auto";
    ll = "eza -al --icons=auto";
    ld = "eza -lhD --icons=auto";
    lt = "eza -a --tree --level=1 --icons=auto";

    ".." = "cd ..";
    "..." = "cd ../..";
    ".3" = "cd ../../..";
    ".4" = "cd ../../../..";
    ".5" = "cd ../../../../..";

    mkdir = "mkdir -p";
    cat = "bat";
  };
}
