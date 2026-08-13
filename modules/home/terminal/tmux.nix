{ ... }:

{
  # Canonical LEENIX tmux configuration, shared across all hosts. The tmux
  # binary is guaranteed by NixOS base (profiles/base.nix); Home Manager owns
  # only this configuration, so package = null avoids duplicate ownership.
  programs.tmux = {
    enable = true;
    package = null;
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 5000;
    keyMode = "vi";
    terminal = "screen-256color";

    extraConfig = ''
      # Mouse support and sensible split/pane behavior
      set -g mouse on
      set -g renumber-windows on
      set -g set-clipboard on
      set -g default-terminal "screen-256color"
      set -g status-style "fg=#d8e3e0,bg=#0b1113"
      set -g status-left "#[fg=#33b8a8]#S "
      set -g window-status-current-format "#[fg=#0b1113,bg=#33b8a8] #I:#W "
      set -g window-status-format "#[fg=#d8e3e0,bg=#182124] #I:#W "
      set -g status-right "#[fg=#d8e3e0]%H:%M"
      set -g pane-border-style "fg=#182124"
      set -g pane-active-border-style "fg=#33b8a8"
    '';
  };
}
