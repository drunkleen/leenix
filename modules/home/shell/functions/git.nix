{ ... }:

{
  programs.zsh.initContent = ''
    gclean() {
      git clean -nd "$@"
    }

    gbranches() {
      git branch --sort=-committerdate "$@"
    }

    glog() {
      git log --oneline --decorate --graph --all "$@"
    }
  '';
}
