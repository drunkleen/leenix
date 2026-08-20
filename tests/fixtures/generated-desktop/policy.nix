# Neutral generated-instance typed policy.
#
# This is the synthetic policy a future installer would emit from user answers.
# It consumes LEENIX ONLY through the public typed `leenix.*` option tree; it
# intentionally does NOT reference internal LEENIX module paths, hosts, or
# personal data. Identity is neutral (alice / generated-desktop).
{ ... }:
{
  system.stateVersion = "26.05";

  leenix = {
    instance = {
      configurationName = "generated-desktop";
      flakePath = "/home/alice/leenix";
      policyPath = "/home/alice/leenix/hosts/generated-desktop/policy.nix";
    };

    host = {
      hostname = "generated-desktop";
      architecture = "x86_64-linux";
    };

    user = {
      username = "alice";
      homeDirectory = "/home/alice";
      extraGroups = [ "wheel" "video" ];
    };

    git = {
      name = "Alice Example";
      email = "alice@example.org";
      branch = "main";
    };

    locale = {
      language = "en_US.UTF-8";
      region = "en_US.UTF-8";
    };

    keyboard.layouts = [ "us" ];
    keyboard.options = [ ];

    cursor = {
      theme = "capitaine-cursors";
      size = 24;
    };

    theme.mode = "dark";

    profiles = {
      base.enable = true;
      desktop.enable = true;
      # Optional catalogs used by the representative leaves below.
      applications.enable = true;
      development.enable = true;
      # laptop intentionally off for this desktop fixture.
    };

    desktop = {
      environment = "hyprland";
      hyprland.enable = true;
      # UWSM-managed session: required alongside hyprland.enable for the
      # supported Hyprland composition (enables the nixpkgs portal + session
      # through Core modules/nixos/desktop/uwsm.nix).
      uwsm.enable = true;
      waybar = {
        enable = true;
        defaultVisible = true;
      };
      hypridle.enable = true;
      hyprlock.enable = true;
      hyprsunset.enable = true;
      browser = "firefox";
      mediaPlayer = "mpv";
      imageViewer = "imv";
      documentViewer = "zathura";
      musicPlayer = "cliamp";
    };

    # Generic hardware policy (no ASUS/NVIDIA machine-specific values).
    hardware = {
      intel.enable = true;
      bluetooth.enable = false;
      camera.privacy = true;
      power-profiles.enable = true;
    };

    # Canonical bootloader so a full system build/toplevel can be evaluated.
    boot.loader = "limine";

    # Representative optional application + editor leaf selections.
    applications.communication.discord.enable = true;
    development.editors.zed.enable = true;

    # Public Disko + storage policy (evaluation-safe; never run disko here).
    disk = {
      device = "/dev/vda";
      layout = "laptop-luks-btrfs";
    };
  };
}
