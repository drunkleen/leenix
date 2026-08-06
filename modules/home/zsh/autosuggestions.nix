let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.zsh = {
    autosuggestion = {
      enable = true;
      highlight = "fg=${leenium.neutral.muted}";
    };
  };
}
