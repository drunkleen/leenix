let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.lazygit = {
    enable = true;
    enableZshIntegration = true;

    settings.gui.theme = {
      activeBorderColor = [
        leenium.accent.teal
        "bold"
      ];
      inactiveBorderColor = [ leenium.neutral.muted ];
      searchingActiveBorderColor = [
        leenium.accent.cyan
        "bold"
      ];
      optionsTextColor = [ leenium.accent.blue ];
      selectedLineBgColor = [ leenium.background.selection ];
      inactiveViewSelectedLineBgColor = [ leenium.background.hover ];
      cherryPickedCommitFgColor = [ leenium.accent.blue ];
      cherryPickedCommitBgColor = [ leenium.background.active ];
      markedBaseCommitFgColor = [ leenium.accent.yellow ];
      markedBaseCommitBgColor = [ leenium.background.active ];
      unstagedChangesColor = [ leenium.accent.red ];
      defaultFgColor = [ leenium.neutral.foreground ];
    };
  };
}
