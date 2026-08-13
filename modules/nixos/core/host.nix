{ variables, lib, ... }:

let
  inherit (lib) attrByPath;
in

{
  leenix = {
    host = {
      hostname = variables.host.hostname;
      architecture = variables.architecture;
      timezone = variables.timezone;
    };

    user = {
      username = variables.user.username;
      homeDirectory = variables.user.homeDirectory;
      extraGroups = variables.user.extraGroups;
    };

    git = {
      name = variables.git.name;
      email = variables.git.email;
      branch = variables.git.branch;
    };

    locale = {
      language = variables.locale.language;
      region = variables.locale.region;
    };

    keyboard = {
      layouts = variables.keyboard.layouts;
      options = variables.keyboard.options;
    };

    cursor = {
      theme = variables.cursor.theme;
      size = variables.cursor.size;
    };

    boot = {
      plymouth.enable = variables.boot.plymouth.enable;
    };

    profiles = {
      base.enable = variables.profiles.base;
      desktop.enable = variables.profiles.desktop;
      laptop.enable = variables.profiles.laptop;
      gaming.enable = variables.profiles.gaming;
      development.enable = variables.profiles.development;
      hardened.enable = variables.profiles.hardened;
      server.enable = variables.profiles.server;
    };

    bootstrap = {
      enable = variables.bootstrap.enable;
      editor = variables.bootstrap.editor;
      wifi = variables.bootstrap.wifi;
      bluetooth = variables.bootstrap.bluetooth;
      audio = variables.bootstrap.audio;
    };

    desktop = {
      environment = variables.desktop.environment;

      hyprland.enable = variables.desktop.hyprland;
      waybar.enable = variables.desktop.waybar;
      hyprlock.enable = variables.desktop.hyprlock;
      hypridle.enable = variables.desktop.hypridle;
      hyprsunset.enable = variables.desktop.hyprsunset;

      autologin.enable = variables.desktop.autologin.enable;

      uwsm.enable = variables.desktop.uwsm.enable;

      browser = variables.desktop.browser;
      mediaPlayer = variables.desktop.mediaPlayer;
      imageViewer = variables.desktop.imageViewer;
      documentViewer = variables.desktop.documentViewer;
      musicPlayer = variables.desktop.musicPlayer;
    };

    theme = {
      mode = variables.theme.mode;
    };

    hardware = {
      asus.enable = variables.hardware.asus;
      asus.model = attrByPath [ "hardware" "asus" "model" ] null variables;
      intel.enable = variables.hardware.intel;
      nvidia.enable = variables.hardware.nvidia.enable;
      bluetooth.enable = variables.hardware.bluetooth;
      power-profiles.enable = variables.hardware.power-profiles;
    };

    disk = {
      device = variables.disk.device;
      layout = variables.disk.layout;
    };

    memory = {
      zram.enable = variables.memory.zram;
      hibernate.enable = variables.memory.hibernate;
    };

    networking = {
      iwd.enable = variables.networking.iwd;
      ssh.enable = variables.networking.ssh.enable;
      # Universal policy default lives in profiles/base.nix (lib.mkDefault true).
      # Host wiring only overrides when the variable is explicitly present, so a
      # base-using host inherits the default without setting anything.
      tailscale.enable = lib.mkIf (attrByPath [ "networking" "tailscale" ] null variables != null)
        (attrByPath [ "networking" "tailscale" ] false variables);
      dns = variables.networking.dns;
      # Declarative VPN profiles. Empty when the host configures none; secrets
      # are file references (privateKeyFile / authUserPassFile), never inline.
      wireguard.interfaces = lib.mkIf (attrByPath [ "networking" "wireguard" "interfaces" ] null variables != null)
        (attrByPath [ "networking" "wireguard" "interfaces" ] { } variables);
      openvpn.profiles = lib.mkIf (attrByPath [ "networking" "openvpn" "profiles" ] null variables != null)
        (attrByPath [ "networking" "openvpn" "profiles" ] { } variables);
    };

    security = {
      pam.enable = variables.security.pam.enable;

      fido2 = {
        enable = variables.security.fido2.enable;
        userPresence = variables.security.fido2.userPresence;
        userVerification = variables.security.fido2.userVerification;
        pinVerification = variables.security.fido2.pinVerification;
      };
    };

    # Universal policy default lives in profiles/base.nix (lib.mkDefault true).
    # Only overridden when the host explicitly declares the variable.
    services.podman.enable = lib.mkIf (attrByPath [ "services" "podman" ] null variables != null)
      (attrByPath [ "services" "podman" ] false variables);
  };
}
