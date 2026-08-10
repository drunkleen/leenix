{ ... }:

{
  programs.zsh.profileExtra = ''
    if [[ $(tty) == /dev/tty1 && -z "$WAYLAND_DISPLAY" && -z "$DISPLAY" ]]; then
      exec uwsm start -F -- Hyprland
    fi
  '';
}
