{
  imports = [
    ./aliases
    ./functions

    ./history.nix
    ./environment.nix
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
