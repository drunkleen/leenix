{
  programs.git.ignores = [
    # Nix
    "result"
    "result-*"

    # direnv and local environments
    ".direnv/"
    ".env"
    ".env.*"
    "!.env.example"

    # Editors
    "*.swp"
    "*.swo"
    "*~"

    # Operating systems
    ".DS_Store"
    "Thumbs.db"
  ];
}
