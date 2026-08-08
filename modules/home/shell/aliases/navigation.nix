{ ... }:

{
  programs.zsh.shellAliases = {
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    ll = "ls -lah";
    la = "ls -A";
    l = "ls -CF";

    c = "clear";
  };
}
