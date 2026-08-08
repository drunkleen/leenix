{ ... }:

{
  programs.zsh.initContent = ''
    mkcd() {
      mkdir -p "$1" && cd "$1"
    }

    croot() {
      cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    }
  '';
}
