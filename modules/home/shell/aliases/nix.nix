{ ... }:

{
  programs.zsh.shellAliases = {
    nb = "nix build";
    nf = "nix flake";
    nfc = "nix flake check";
    nfu = "nix flake update";

    ndev = "nix develop";
    ne = "nix eval";
    ns = "nix shell";

    hms = "home-manager switch --flake .#\"${USER}@$(hostname)\"";
  };
}
