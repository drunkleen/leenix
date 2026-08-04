{ vars, ... }:

{
  programs.zsh.initContent = ''
    function rebuild() {
      sudo nixos-rebuild switch \
        --flake "$HOME/nix-config#${vars.hostname}"
    }

    function rebuild-build() {
      sudo nixos-rebuild build \
        --flake "$HOME/nix-config#${vars.hostname}"
    }

    function rebuild-test() {
      sudo nixos-rebuild test \
        --flake "$HOME/nix-config#${vars.hostname}"
    }

    function update() {
      local repo="$HOME/nix-config"

      echo "Updating flake inputs..."
      nix flake update --flake "$repo" || return 1

      echo "Building ${vars.hostname}..."
      sudo nixos-rebuild build \
        --flake "$repo#${vars.hostname}" || return 1

      echo "Switching ${vars.hostname}..."
      sudo nixos-rebuild switch \
        --flake "$repo#${vars.hostname}"
    }

    function cleanup() {
      nix-collect-garbage -d &&
        sudo nix-collect-garbage -d
    }

    function generations() {
      sudo nixos-rebuild list-generations
    }
  '';
}
