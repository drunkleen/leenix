{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      path = "$HOME/.local/share/zsh/history";
      size = 10000;
      save = 10000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ls = "eza";
      l = "eza -la";
      ll = "eza -lah";
      la = "eza -a";
      lt = "eza --tree";

      cat = "bat";
      grep = "rg";

      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      cls = "clear";

      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      lg = "lazygit";

      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#tuf-f15";
      rebuild-build = "sudo nixos-rebuild build --flake ~/nix-config#tuf-f15";
      flake-check = "nix flake check ~/nix-config";

      nix-clean = "nix-collect-garbage -d";
      nix-clean-system = "sudo nix-collect-garbage -d";
    };

    initContent = ''
      bindkey -e

      setopt AUTO_CD
      setopt CORRECT
      setopt HIST_IGNORE_ALL_DUPS
      setopt SHARE_HISTORY

      export PATH="$HOME/.local/bin:$HOME/go/bin:$PATH"
    '';
  };

  home.packages = with pkgs; [
    lazygit
  ];
}
