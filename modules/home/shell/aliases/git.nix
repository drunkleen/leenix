{ ... }:

{
  programs.zsh.shellAliases = {
    gs = "git status";
    gst = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gca = "git commit --amend";
    gd = "git diff";
    gds = "git diff --staged";
    gp = "git push";
    gpl = "git pull --rebase";
    gl = "git log --oneline --decorate --graph";
    glo = "git log --oneline --decorate";
    gb = "git branch";
    gba = "git branch --all";
    gco = "git checkout";
    gsw = "git switch";
  };
}
