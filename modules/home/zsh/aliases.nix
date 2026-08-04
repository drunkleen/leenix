{
  programs.zsh.shellAliases = {
    # Navigation
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";
    nixc = "nixcfg";

    # Listing
    ls = "eza --icons=auto";
    l = "eza -1 --icons=auto";
    ll = "eza -l --icons=auto";
    la = "eza -la --icons=auto";
    lla = "eza -la --icons=auto";
    ld = "eza -lD --icons=auto";
    lt = "eza --tree --icons=auto";

    # Files
    cat = "bat";
    grep = "rg";
    find = "fd";
    cls = "clear";

    # Git
    gs = "git status";
    ga = "git add";
    gaa = "git add --all";
    gc = "git commit";
    gp = "git push";
    gl = "git pull";
    gd = "git diff";
    gds = "git diff --staged";
    gb = "git branch";
    gco = "git checkout";
    lg = "lazygit";

    # Nix
    nb = "rebuild-build";
    nsw = "rebuild";
    nt = "rebuild-test";
    nf = "nix flake";
    nfu = "nix flake update";
    nd = "nix develop";
    nr = "nix run";
    ns = "nix search nixpkgs";
    ng = "generations";

    # Maintenance
    nix-clean = "nix-collect-garbage -d";
    nix-clean-system = "sudo nix-collect-garbage -d";
  };
}
