{ ... }:

{
  programs.zsh.initContent = ''
    mktempdir() {
      local dir
      dir="$(mktemp -d)" || return
      cd "$dir" || return
    }

    extract() {
      if [[ ! -f "$1" ]]; then
        echo "File not found: $1" >&2
        return 1
      fi

      case "$1" in
        *.tar.gz|*.tgz) tar -xzf "$1" ;;
        *.tar.bz2|*.tbz2) tar -xjf "$1" ;;
        *.tar.xz|*.txz) tar -xJf "$1" ;;
        *.tar) tar -xf "$1" ;;
        *.zip) unzip "$1" ;;
        *) echo "Unsupported archive: $1" >&2; return 1 ;;
      esac
    }
  '';
}
