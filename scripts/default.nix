{ pkgs }:

{
  toggleTouchpad = pkgs.writeShellApplication {
    name = "leenium-toggle-touchpad";

    runtimeInputs = with pkgs; [
      hyprland
      swayosd
      coreutils
    ];

    text = builtins.readFile ./toggle-touchpad.sh;
  };
}