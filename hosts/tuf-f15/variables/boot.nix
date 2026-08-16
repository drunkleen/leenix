{
  boot = {
    # Declarative kernel policy. stable preserves the NixOS default behavior
    # (pkgs.linuxPackages) while making ownership explicit. Other hosts may
    # use "default" to leave kernel ownership untouched.
    kernel = {
      channel = "stable";
      version = null;
    };

    plymouth.enable = true;
  };
}
