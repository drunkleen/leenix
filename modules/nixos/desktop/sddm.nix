{
  config,
  lib,
  pkgs,
  ...
}:

# LEENIX SDDM display-manager module.
#
# SDDM in Wayland mode owns the graphical VT and launches the user session.
# Autologin logs the configured LEENIX user straight into the UWSM-managed
# Hyprland session (`hyprland-uwsm` — the native session shipped by the
# Hyprland package), so the boot UX stays "LUKS password only". On logout the
# LEENIUM greeter is shown (relogin disabled).
#
# The Wayland greeter runs a minimal, Nix-owned Hyprland compositor that is
# fully independent of the user's Home Manager Hyprland configuration.

let
  cfg = config.leenix.desktop.sddm;
  user = config.leenix.user.username;
  theme = pkgs.callPackage ./sddm/theme.nix { };

  # Minimal Hyprland config for the SDDM Wayland greeter. Independent from
  # ~/.config/hypr/*: no user autostart, no Waybar, no wallpaper daemon, no
  # user binds, no animations, no Hyprland branding/splash.
  greeterConfig = pkgs.writeText "sddm-hyprland.lua" ''
    hl.config({
      misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
      },
      animations = {
        enabled = false,
      },
    })
  '';
in

{
  config = lib.mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      # Pinned NixOS exposes only weston/kwin in the enum, so the Hyprland
      # greeter compositor requires the internal compositorCommand override.
      wayland.compositorCommand = "${pkgs.hyprland}/bin/start-hyprland -- --config ${greeterConfig}";
      theme = "leenium";
      autoLogin.relogin = false;
    };

    services.displayManager.autoLogin = {
      enable = cfg.autologin;
      inherit user;
    };

    # The UWSM-managed session shipped natively by the Hyprland package.
    services.displayManager.defaultSession = "hyprland-uwsm";

    # Make the LEENIUM theme resolvable by SDDM (ThemeDir points into the
    # system profile's share/sddm/themes).
    environment.systemPackages = [ theme ];
  };
}