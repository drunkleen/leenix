{ variables, lib, ... }:

let
  inherit (lib) attrByPath;

  # Development catalog keys drive the generated host wiring below. The merged
  # host variables expose variables.development.<category>.<leaf>; absent values
  # safely default to false (no `or true`). Hosts that declare any development
  # policy must import profiles/development.nix so the options/assertions are
  # active.
  devCatalog = import ../development/catalog.nix;

  devWiring = lib.mkIf (attrByPath [ "development" ] null variables != null) (
    builtins.mapAttrs (cat: leaves:
      builtins.mapAttrs (leaf: _:
        { enable = attrByPath [ "development" cat leaf ] false variables; })
        leaves)
      devCatalog
  );

  # Cybersecurity catalog wiring (same pattern).
  cybCatalog = import ../cybersecurity/catalog.nix;

  cybWiring = lib.mkIf (attrByPath [ "cybersecurity" ] null variables != null) (
    builtins.mapAttrs (cat: leaves:
      builtins.mapAttrs (leaf: _:
        { enable = attrByPath [ "cybersecurity" cat leaf ] false variables; })
        leaves)
      cybCatalog
  );

  # AI catalog wiring (same pattern).
  aiCatalog = import ../ai/catalog.nix;

  aiWiring = lib.mkIf (attrByPath [ "ai" ] null variables != null) (
    builtins.mapAttrs (cat: leaves:
      builtins.mapAttrs (leaf: _:
        { enable = attrByPath [ "ai" cat leaf ] false variables; })
        leaves)
      aiCatalog
  );

  # Applications catalog wiring (same pattern).
  appCatalog = import ../applications/catalog.nix;

  appWiring = lib.mkIf (attrByPath [ "applications" ] null variables != null) (
    builtins.mapAttrs (cat: leaves:
      builtins.mapAttrs (leaf: _:
        { enable = attrByPath [ "applications" cat leaf ] false variables; })
        leaves)
      appCatalog
  );
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

      visual.enable = attrByPath [ "boot" "visual" "enable" ] true variables;
      visual.verbose = attrByPath [ "boot" "visual" "verbose" ] false variables;

      kernel = {
        channel = attrByPath [ "boot" "kernel" "channel" ] "default" variables;
        version = attrByPath [ "boot" "kernel" "version" ] null variables;
      };
    };

    profiles = {
      base.enable = variables.profiles.base;
      desktop.enable = variables.profiles.desktop;
      laptop.enable = variables.profiles.laptop;
      gaming.enable = variables.profiles.gaming;
      development.enable = variables.profiles.development;
      hardened.enable = variables.profiles.hardened;
      server.enable = variables.profiles.server;
      cybersecurity.enable = attrByPath [ "profiles" "cybersecurity" ] false variables;
      ai.enable = attrByPath [ "profiles" "ai" ] false variables;
      applications.enable = attrByPath [ "profiles" "applications" ] false variables;
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
      waybar.enable = variables.desktop.waybar.enable;
      waybar.defaultVisible = variables.desktop.waybar.defaultVisible;
      hyprlock.enable = variables.desktop.hyprlock;
      hypridle.enable = variables.desktop.hypridle;
      hyprsunset.enable = variables.desktop.hyprsunset;

      sddm.enable = attrByPath [ "desktop" "sddm" "enable" ] false variables;
      sddm.autologin = attrByPath [ "desktop" "sddm" "autologin" ] true variables;

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

      # LEENIX default camera privacy is ON (declarative deauthorization) unless
      # a host explicitly opts out via variables.hardware.camera.privacy = false.
      camera.privacy = attrByPath [ "hardware" "camera" "privacy" ] true variables;
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
      ssh = {
        enable = attrByPath [ "networking" "ssh" "enable" ] false variables;
        autoStart = attrByPath [ "networking" "ssh" "autoStart" ] true variables;
        port = attrByPath [ "networking" "ssh" "port" ] 22 variables;
        passwordAuthentication = attrByPath [ "networking" "ssh" "passwordAuthentication" ] false variables;
        keyboardInteractiveAuthentication = attrByPath [ "networking" "ssh" "keyboardInteractiveAuthentication" ] false variables;
        permitRootLogin = attrByPath [ "networking" "ssh" "permitRootLogin" ] "no" variables;
        allowedUsers = attrByPath [ "networking" "ssh" "allowedUsers" ] [ ] variables;
        publicKeys = attrByPath [ "networking" "ssh" "publicKeys" ] [ ] variables;
      };
      # Universal policy default lives in profiles/base.nix (lib.mkDefault true).
      # Host wiring only overrides when the variable is explicitly present, so a
      # base-using host inherits the default without setting anything.
      tailscale.enable = lib.mkIf (attrByPath [ "networking" "tailscale" ] null variables != null)
        (attrByPath [ "networking" "tailscale" ] false variables);
      # LEENIX DNS policy is authoritative: acceptDns defaults to false unless
      # the host explicitly opts in (variables.networking.tailscale.acceptDns).
      tailscale.acceptDns = attrByPath [ "networking" "tailscale" "acceptDns" ] false variables;
      dns = variables.networking.dns;
      # Declarative VPN profiles. Empty when the host configures none; secrets
      # are file references (privateKeyFile / authUserPassFile), never inline.
      wireguard.interfaces = lib.mkIf (attrByPath [ "networking" "wireguard" "interfaces" ] null variables != null)
        (attrByPath [ "networking" "wireguard" "interfaces" ] { } variables);
      openvpn.profiles = lib.mkIf (attrByPath [ "networking" "openvpn" "profiles" ] null variables != null)
        (attrByPath [ "networking" "openvpn" "profiles" ] { } variables);
    };

    security.firewall = {
      enable = attrByPath [ "security" "firewall" "enable" ] false variables;
      rules = attrByPath [ "security" "firewall" "rules" ] [ ] variables;
    };

    security = {
      pam.enable = variables.security.pam.enable;
      passwordlessSudo = attrByPath [ "security" "passwordlessSudo" ] false variables;

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

    # Generated development catalog wiring (absent values -> false).
    development = devWiring;

    # Generated cybersecurity catalog wiring (absent values -> false).
    cybersecurity = cybWiring;

    # Generated AI catalog wiring (absent values -> false).
    ai = aiWiring;

    # Generated applications catalog wiring (absent values -> false).
    applications = appWiring;
  };
}
