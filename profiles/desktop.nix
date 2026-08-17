{
  config,
  lib,
  ...
}:

{
  imports = [
    ../modules/nixos/desktop/appearance.nix
    ../modules/nixos/desktop/bootstrap.nix
    ../modules/nixos/desktop/file-manager.nix
    ../modules/nixos/desktop/uwsm.nix
    ../modules/nixos/desktop/sddm.nix
    ../modules/nixos/desktop/swayosd.nix
    ../modules/nixos/hardware/camera.nix
    ../modules/nixos/security/pam.nix
    # Editors/IDEs are desktop-capable development categories; the composition
    # module is also imported by profiles/development.nix (idempotent merge).
    ../modules/nixos/development
  ];

  config = lib.mkIf config.leenix.profiles.desktop.enable {
    leenix.bootstrap.enable = lib.mkDefault true;
    # Desktop default: VS Code on, unless the host explicitly overrides via
    # variables.development.editors.vscode (null -> inherit, false/true override).
    leenix.development.editors.vscode.enable = lib.mkDefault true;
  };
}
