{ lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in

{
  imports = [
    # Development catalog: generated typed options, always-loaded assertions
    # (profile gate / unfree / platform) and derived consistency checks.
    ../development/options.nix
    ../development/assertions.nix
    ../development/checks.nix
    # Cybersecurity catalog: same always-loaded pattern.
    ../cybersecurity/options.nix
    ../cybersecurity/assertions.nix
    ../cybersecurity/checks.nix
    # AI catalog: same always-loaded pattern.
    ../ai/options.nix
    ../ai/assertions.nix
    ../ai/checks.nix
  ];

  options.leenix = {
    host = {
      hostname = mkOption {
        type = types.str;
        description = "System hostname.";
      };

      architecture = mkOption {
        type = types.str;
        description = "System architecture.";
      };

      timezone = mkOption {
        type = types.str;
        default = "UTC";
        description = "System timezone.";
      };
    };

    user = {
      username = mkOption {
        type = types.str;
        description = "Primary username.";
      };

      homeDirectory = mkOption {
        type = types.str;
        description = "Primary user's home directory.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = "Additional groups for the primary user.";
      };
    };

    git = {
      name = mkOption {
        type = types.str;
        description = "Git user name.";
      };

      email = mkOption {
        type = types.str;
        description = "Git user email.";
      };

      branch = mkOption {
        type = types.str;
        default = "master";
        description = "Default Git branch.";
      };
    };

    locale = {
      language = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
        description = "Application/system language and message translations (also drives weekday/month names).";
      };

      region = mkOption {
        type = types.str;
        default = "de_DE.UTF-8";
        description = "Regional formatting (numbers, currency, addresses, measurement, paper, telephone).";
      };
    };

    keyboard = {
      layouts = mkOption {
        type = types.listOf types.str;
        default = [ "us" ];
      };

      options = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };

    cursor = {
      theme = mkOption {
        type = types.str;
        description = "Cursor theme name.";
      };

      size = mkOption {
        type = types.int;
        description = "Cursor size in pixels.";
      };
    };

    boot = {
      plymouth.enable = mkEnableOption "Plymouth boot splash screen";

      visual = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Seamless boot visuals: quiet normal boot, keep Plymouth visible until the graphical session is ready, and bounded fallback reveal.";
        };

        verbose = mkOption {
          type = types.bool;
          default = false;
          description = "Verbose/recovery boot: full console output and visible systemd status (loglevel 7). Off by default.";
        };
      };

      kernel = {
        channel = mkOption {
          type = types.enum [
            "default"
            "stable"
            "latest"
            "version"
          ];
          default = "default";
          description = "Kernel ownership policy. default: no boot.kernelPackages assignment (NixOS default or a specialized hardware module owns the kernel). stable: pkgs.linuxPackages. latest: pkgs.linuxPackages_latest. version: a specific series (e.g. \"6.18\") selected from the pinned nixpkgs.";
        };

        version = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Kernel series (e.g. \"6.18\") used when channel = \"version\". Exact patch versions are rejected; nixpkgs controls the patch release.";
        };
      };
    };

    profiles = {
      base.enable = mkEnableOption "base profile";
      desktop.enable = mkEnableOption "desktop profile";
      laptop.enable = mkEnableOption "laptop profile";
      gaming.enable = mkEnableOption "gaming profile";
      development.enable = mkEnableOption "development profile";
      hardened.enable = mkEnableOption "hardened profile";
      server.enable = mkEnableOption "server profile";
      cybersecurity.enable = mkEnableOption "cybersecurity profile";
      ai.enable = mkEnableOption "AI profile";
    };

    bootstrap = {
      enable = mkEnableOption "bootstrap desktop environment";

      editor = mkOption {
        type = types.str;
        default = "vscode";
      };

      wifi = mkOption {
        type = types.str;
        default = "impala";
      };

      bluetooth = mkOption {
        type = types.str;
        default = "bluetui";
      };

      audio = mkOption {
        type = types.str;
        default = "wiremix";
      };
    };

    desktop = {
      environment = mkOption {
        type = types.enum [
          "none"
          "hyprland"
        ];

        default = "none";
      };

      hyprland.enable = mkEnableOption "Hyprland";
      waybar.enable = mkEnableOption "Waybar";
      hyprlock.enable = mkEnableOption "Hyprlock";
      hypridle.enable = mkEnableOption "Hypridle";
      hyprsunset.enable = mkEnableOption "Hyprsunset";

      sddm = {
        enable = mkEnableOption "SDDM display manager (Wayland greeter)";

        autologin = mkOption {
          type = types.bool;
          default = true;
          description = "Automatically log in the configured LEENIX user via SDDM into the default UWSM Hyprland session (LUKS stays the boot password).";
        };
      };

      uwsm.enable = mkEnableOption "UWSM-managed Wayland session";

      browser = mkOption {
        type = types.enum [
          "firefox"
          "chromium"
          "google-chrome"
          "brave"
          "vivaldi"
          "librewolf"
        ];

        default = "firefox";
        description = "Default web browser (mutually exclusive: only this browser is installed).";
      };

      mediaPlayer = mkOption {
        type = types.enum [
          "mpv"
        ];

        default = "mpv";
        description = "Default local media player (mutually exclusive: only this player is installed).";
      };

      imageViewer = mkOption {
        type = types.enum [
          "imv"
        ];

        default = "imv";
        description = "Default image viewer (mutually exclusive: only this viewer is installed).";
      };

      documentViewer = mkOption {
        type = types.enum [
          "zathura"
        ];

        default = "zathura";
        description = "Default document/PDF viewer (mutually exclusive: only this viewer is installed).";
      };

      musicPlayer = mkOption {
        type = types.enum [
          "cliamp"
        ];

        default = "cliamp";
        description = "Terminal music player (owns audio MIME types through its LEENIX desktop entry).";
      };
    };

    theme = {
      mode = mkOption {
        type = types.enum [
          "dark"
          "light"
        ];

        default = "dark";
        description = "System color-scheme preference.";
      };
    };

    hardware = {
      asus.enable = mkEnableOption "ASUS hardware support";

      asus.model = mkOption {
        type = types.nullOr (types.enum [
          "rog"
          "expertbook-b9406"
          "zenbook-ux5406aa"
        ]);
        default = null;
        description = "ASUS model family for model-specific helpers. Only the matching detector is installed.";
      };

      intel.enable = mkEnableOption "Intel hardware support";
      nvidia.enable = mkEnableOption "NVIDIA hardware support";
      bluetooth.enable = mkEnableOption "Bluetooth support";
      power-profiles.enable = mkEnableOption "power-profiles-daemon";

      # Camera privacy is DECLARATIVE host policy: when enabled, USB video-class
      # devices (UVC cameras) are deauthorized at the udev level so they are
      # physically unavailable. The runtime leenix-camera command re-authorizes a
      # camera for the current session; the next boot follows this policy again.
      camera.privacy = mkOption {
        type = types.bool;
        default = true;
        description = "Deauthorize USB video devices (cameras) at the udev level. LEENIX default: privacy ON (camera disabled).";
      };
    };

    disk = {
      device = mkOption {
        type = types.str;
        description = "Target disk.";
      };

      layout = mkOption {
        type = types.str;
        description = "Disk layout identifier.";
      };
    };

    memory = {
      zram.enable = mkEnableOption "ZRAM";
      hibernate.enable = mkEnableOption "hibernation";
    };

    networking = {
      iwd.enable = mkEnableOption "iwd";

      tailscale = {
        enable = mkEnableOption "Tailscale client";

        # LEENIX DNS policy is authoritative. acceptDns=false means the client
        # rejects tailnet/MagicDNS settings so they can never hijack the
        # resolver; a host may explicitly opt into true.
        acceptDns = mkOption {
          type = types.bool;
          default = false;
          description = "Accept tailnet DNS (MagicDNS) settings from the Tailscale control plane.";
        };
      };

      dns = mkOption {
        type = types.submodule {
          options = {
            mode = mkOption {
              type = types.enum [
                "system"
                "custom"
              ];
              default = "system";
              description = "DNS mode: system = DHCP-provided, custom = explicit ordered servers only.";
            };
            servers = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Ordered DNS servers used in custom mode (IPv4/IPv6).";
            };
          };
        };
        default = { };
        description = "Declarative DNS policy.";
      };
    };

    security = {
      pam.enable = mkEnableOption "PAM";

      passwordlessSudo = mkOption {
        type = types.bool;
        default = false;
        description = "Allow passwordless sudo for members of the wheel group (declarative host/local policy).";
      };

      fido2 = {
        enable = mkEnableOption "FIDO2 authentication";

        userPresence = mkOption {
          type = types.bool;
          default = true;
        };

        userVerification = mkOption {
          type = types.bool;
          default = false;
        };

        pinVerification = mkOption {
          type = types.bool;
          default = true;
        };
      };
    };

    services = {
      podman.enable = mkEnableOption "Podman container baseline";
    };
  };
}
