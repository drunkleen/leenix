{
  programs.zsh.initContent = ''
    function mkcd() {
      if (( $# != 1 )); then
        echo "usage: mkcd <directory>" >&2
        return 2
      fi

      mkdir -p -- "$1" && cd -- "$1"
    }

    function nixcfg() {
      cd "$HOME/nix-config" || return 1
    }
  '';
}
