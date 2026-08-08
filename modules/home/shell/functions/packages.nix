{ ... }:

{
  programs.zsh.initContent = ''
    update() {
      pkg update "$@" || return 1

      if command -v yay >/dev/null 2>&1; then
        aur update "$@" || return 1
      else
        printf 'Skipping AUR update: yay not installed\n' >&2
      fi
    }

    pkg() {
      local subcmd="''${1:-help}"
      shift || true

      case "$subcmd" in
        update)
          sudo pacman -Syu "$@"
          ;;

        install)
          (( $# )) || {
            printf 'Usage: pkg install <package...>\n' >&2
            return 1
          }
          sudo pacman -S "$@"
          ;;

        remove)
          (( $# )) || {
            printf 'Usage: pkg remove <package...>\n' >&2
            return 1
          }
          sudo pacman -R "$@"
          ;;

        remove-deps)
          (( $# )) || {
            printf 'Usage: pkg remove-deps <package...>\n' >&2
            return 1
          }
          sudo pacman -Rns "$@"
          ;;

        search)
          (( $# )) || {
            printf 'Usage: pkg search <query>\n' >&2
            return 1
          }
          pacman -Ss "$@"
          ;;

        list)
          pacman -Q
          ;;

        info)
          (( $# )) || {
            printf 'Usage: pkg info <package...>\n' >&2
            return 1
          }
          pacman -Qi "$@"
          ;;

        help|-h|--help)
          printf '%s\n' \
            'pkg update' \
            'pkg install PKG' \
            'pkg remove PKG' \
            'pkg remove-deps PKG' \
            'pkg search QUERY' \
            'pkg list' \
            'pkg info PKG'
          ;;

        *)
          printf 'Unknown pkg command: %s\n' "$subcmd" >&2
          printf 'Try: pkg help\n' >&2
          return 1
          ;;
      esac
    }

    aur() {
      local subcmd="''${1:-help}"
      shift || true

      command -v yay >/dev/null 2>&1 || {
        printf 'Missing command: yay\n' >&2
        return 1
      }

      case "$subcmd" in
        update)
          yay -Sua "$@"
          ;;

        install)
          (( $# )) || {
            printf 'Usage: aur install <package...>\n' >&2
            return 1
          }
          yay -S "$@"
          ;;

        remove)
          (( $# )) || {
            printf 'Usage: aur remove <package...>\n' >&2
            return 1
          }
          yay -R "$@"
          ;;

        remove-deps)
          (( $# )) || {
            printf 'Usage: aur remove-deps <package...>\n' >&2
            return 1
          }
          yay -Rns "$@"
          ;;

        search)
          (( $# )) || {
            printf 'Usage: aur search <query>\n' >&2
            return 1
          }
          yay -Ss "$@"
          ;;

        list)
          yay -Qm
          ;;

        info)
          (( $# )) || {
            printf 'Usage: aur info <package...>\n' >&2
            return 1
          }
          yay -Qi "$@"
          ;;

        help|-h|--help)
          printf '%s\n' \
            'aur update' \
            'aur install PKG' \
            'aur remove PKG' \
            'aur remove-deps PKG' \
            'aur search QUERY' \
            'aur list' \
            'aur info PKG'
          ;;

        *)
          printf 'Unknown aur command: %s\n' "$subcmd" >&2
          printf 'Try: aur help\n' >&2
          return 1
          ;;
      esac
    }
  '';
}
