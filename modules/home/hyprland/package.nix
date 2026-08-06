{
  wayland.windowManager.hyprland = {
    enable = true;

    # Hyprland is installed system-wide by the NixOS module.
    package = null;
    portalPackage = null;

    # Our current modular settings use Hyprlang syntax.
    configType = "hyprlang";

    # UWSM manages the graphical session.
    systemd.enable = false;
  };
}
