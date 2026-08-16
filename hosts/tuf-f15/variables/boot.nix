{
  boot = {
    # Declarative kernel policy. stable preserves the NixOS default behavior
    # (pkgs.linuxPackages) while making ownership explicit. Other hosts may
    # use "default" to leave kernel ownership untouched.
    kernel = {
      channel = "latest";
      version = null;
    };

    plymouth.enable = true;

    # Seamless boot visuals: quiet normal boot + Plymouth kept visible until
    # the Hyprland graphical session reports readiness (with bounded fallback).
    visual = {
      enable = true;
      verbose = false;
    };
  };
}
