{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  home.activation.setDefaultShell =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    current_shell="$(getent passwd "$USER" | cut -d: -f7)"

    if [ "$current_shell" != "$HOME/.nix-profile/bin/zsh" ]; then
      "$HOME/.nix-profile/bin/zsh" -c \
      "chsh -s '$HOME/.nix-profile/bin/zsh' '$USER'"
    fi
  '';
}
