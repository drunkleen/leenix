{ lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    ;
in

{
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
      default = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
      };

      extra = mkOption {
        type = types.attrsOf types.str;
        default = { };
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
    };

    profiles = {
      base.enable = mkEnableOption "base profile";
      desktop.enable = mkEnableOption "desktop profile";
      laptop.enable = mkEnableOption "laptop profile";
      gaming.enable = mkEnableOption "gaming profile";
      development.enable = mkEnableOption "development profile";
      hardened.enable = mkEnableOption "hardened profile";
      server.enable = mkEnableOption "server profile";
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

      autologin.enable = mkEnableOption "automatic login on tty1";

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
      intel.enable = mkEnableOption "Intel hardware support";
      nvidia.enable = mkEnableOption "NVIDIA hardware support";
      bluetooth.enable = mkEnableOption "Bluetooth support";
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
      ssh.enable = mkEnableOption "SSH";
    };

    security = {
      pam.enable = mkEnableOption "PAM";

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
  };
}
