{
  imports = [
    ./aliases.nix
    ./functions.nix
    ./environment.nix
    ./history.nix
    ./options.nix
    ./completion.nix
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };
}
