{
  imports = [
    ./colors.nix
    ./keybindings.nix
    ./preview.nix
  ];

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
}
