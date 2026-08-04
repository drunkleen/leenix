{
  programs.zsh.shellAliases = {

    nb = "rebuild-build";
    nsw = "rebuild";
    nt = "rebuild-test";

    nf = "nix flake";
    nfu = "nix flake update";

    nd = "nix develop";
    nr = "nix run";

    ns = "nix search nixpkgs";

    ng = "generations";

    nc = "nix-collect-garbage -d";
    ncs = "sudo nix-collect-garbage -d";

    nfmt = "nix fmt";
  };
}
