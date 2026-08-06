{ pkgs, touchpadDevice }:

{
  toggleTouchpad = pkgs.writeShellApplication {
    name = "leenix-toggle-touchpad";

    runtimeInputs = with pkgs; [
      hyprland
      swayosd
      coreutils
    ];

    text = ''
      export LEENIX_TOUCHPAD_DEVICE=${pkgs.lib.escapeShellArg touchpadDevice}
      ${builtins.readFile ./toggle-touchpad.sh}
    '';
  };
}
