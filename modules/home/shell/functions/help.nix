{ ... }:

{
  programs.zsh.initContent = ''
    shellhelp() {
      printf '%s\n\n' 'Available shell shortcuts'

      printf '%s\n' 'Navigation'
      printf '  %-14s %s\n' 'c, cls' 'Clear the terminal'
      printf '  %-14s %s\n' 'ls' 'List files with eza and icons'
      printf '  %-14s %s\n' 'l' 'Long file list'
      printf '  %-14s %s\n' 'll' 'Long all-files list'
      printf '  %-14s %s\n' 'ld' 'Long directory-only list'
      printf '  %-14s %s\n' 'lt' 'Tree view, depth 1'
      printf '  %-14s %s\n' 'lz' 'Fallback ls alias'
      printf '  %-14s %s\n' '.. / ... / .3' 'Go up directories'
      printf '  %-14s %s\n' '.4 / .5' 'Go up 4 or 5 directories'
      printf '  %-14s %s\n' 'mkdir' 'Create parent directories'

      printf '\n%s\n' 'Editors and Files'
      printf '  %-14s %s\n' 'vc' 'Open VS Code'
      printf '  %-14s %s\n' 'vim' 'Use Neovim'
      printf '  %-14s %s\n' 'cat' 'Use bat'
      printf '  %-14s %s\n' 'open PATH' 'Open with xdg-open'
      printf '  %-14s %s\n' 'opendir [PATH]' 'Open directory in Nautilus'

      printf '\n%s\n' 'Packages'
      printf '  %-18s %s\n' 'update' 'Update repo and AUR packages'
      printf '  %-18s %s\n' 'pkg install PKG' 'Install repo package(s)'
      printf '  %-18s %s\n' 'pkg remove PKG' 'Remove repo package(s)'
      printf '  %-18s %s\n' 'pkg search QUERY' 'Search repositories'
      printf '  %-18s %s\n' 'pkg list' 'List installed packages'
      printf '  %-18s %s\n' 'pkg info PKG' 'Show package info'
      printf '  %-18s %s\n' 'aur install PKG' 'Install AUR package(s)'
      printf '  %-18s %s\n' 'aur remove PKG' 'Remove AUR package(s)'
      printf '  %-18s %s\n' 'aur search QUERY' 'Search AUR'
      printf '  %-18s %s\n' 'aur list' 'List installed AUR packages'
      printf '  %-18s %s\n' 'aur info PKG' 'Show AUR package info'

      printf '\n%s\n' 'Network'
      printf '  %-14s %s\n' 'iporigin ARG' 'Resolve and inspect IP/domain'
      printf '  %-14s %s\n' 'ips' 'Show local and public IPs'

      printf '\n%s\n' 'Help'
      printf '  %-14s %s\n' 'shellhelp' 'Show this help'
    }
  '';
}
