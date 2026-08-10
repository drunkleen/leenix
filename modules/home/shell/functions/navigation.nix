{ ... }:

{
  programs.zsh.initContent = ''
    open() {
      if ! command -v xdg-open >/dev/null 2>&1; then
        echo "Missing command: xdg-open" >&2
        return 1
      fi

      xdg-open "$@" >/dev/null 2>&1 &
    }

    opendir() {
      leenix-launch-file-manager "''${1:-.}" >/dev/null 2>&1 &
    }

    cd() {
      if (( $# == 0 )); then
        builtin cd "$HOME"
          elif [[ "$1" == -* || "$1" == */* || -d "$1" ]]; then
          builtin cd "$@"
      else
        z "$@"
      fi
    }
  '';
}
