{
  programs.zsh.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Files and listing
    ls= "eza --icons=auto";
    l= "eza -1 --icons=auto";
    ll= "eza -l --icons=auto";
    la= "eza -la --icons=auto";
    lt= "eza --tree --icons=auto";
    cat = "bat";
    grep = "rg";

    # Git
    gs = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    lg = "lazygit";

    # Nix
    nb = "sudo nixos-rebuild build --flake ~/nix-config#tuf-f15";
    nsw = "sudo nixos-rebuild switch --flake ~/nix-config#tuf-f15";
    nt = "sudo nixos-rebuild test --flake ~/nix-config#tuf-f15";
    nf = "nix flake";
    nfu = "nix flake update";
    nd = "nix develop";
    nr = "nix run";
    ns = "nix search nixpkgs";

    # Maintenance
    nix-clean = "nix-collect-garbage -d";
    nix-clean-system = "sudo nix-collect-garbage -d";

    # Misc
    cls = "clear";
  };
}
