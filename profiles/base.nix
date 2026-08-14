{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.leenix.profiles.base;
  user = config.leenix.user;
in

{
  imports = [
    ../modules/nixos/networking/dns.nix
    ../modules/nixos/networking/tailscale.nix
    ../modules/nixos/networking/ssh.nix
    ../modules/nixos/networking/wireguard.nix
    ../modules/nixos/networking/openvpn.nix
    ../modules/nixos/services/podman.nix
    ../modules/nixos/security/firewall.nix
  ];

  config = lib.mkIf cfg.enable {
    networking.hostName = config.leenix.host.hostname;

    # Universal LEENIX baseline: Tailscale and Podman are ON by default.
    # profiles/base.nix is the single default-policy owner; a host can still
    # override per capability via its variables (networking.tailscale /
    # services.podman = false) through host.nix conditional wiring.
    leenix.networking.tailscale.enable = lib.mkDefault true;
    leenix.services.podman.enable = lib.mkDefault true;

    time.timeZone = config.leenix.host.timezone;

    # Two-dimension locale policy: LANGUAGE drives the UI/messages/date
    # language (defaultLocale plus LC_MESSAGES and LC_TIME); REGION drives
    # regional formatting (numbers, currency, address, measurement, paper,
    # telephone, name, identification). LC_COLLATE and LC_CTYPE are left to
    # inherit from defaultLocale. LC_ALL is never set.
    i18n = {
      defaultLocale = config.leenix.locale.language;

      extraLocaleSettings = {
        LC_MESSAGES = config.leenix.locale.language;
        LC_TIME = config.leenix.locale.language;

        LC_ADDRESS = config.leenix.locale.region;
        LC_IDENTIFICATION = config.leenix.locale.region;
        LC_MEASUREMENT = config.leenix.locale.region;
        LC_MONETARY = config.leenix.locale.region;
        LC_NAME = config.leenix.locale.region;
        LC_NUMERIC = config.leenix.locale.region;
        LC_PAPER = config.leenix.locale.region;
        LC_TELEPHONE = config.leenix.locale.region;
      };
    };

    services.xserver.xkb = {
      layout = builtins.concatStringsSep "," config.leenix.keyboard.layouts;
      options = builtins.concatStringsSep "," config.leenix.keyboard.options;
    };

    users.users.${user.username} = {
      isNormalUser = true;
      home = user.homeDirectory;
      extraGroups = user.extraGroups;
      shell = pkgs.zsh;
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = true;
    };

    # Canonical universal terminal/CLI binaries, guaranteed by NixOS base even
    # on a headless/SSH host independent of any Home Manager composition.
    # Home Manager owns only their user configuration/integration.
    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      vim
      nano
      which
      zsh
      tmux
      neovim
      yazi
      eza
      bat
      fzf
      zoxide
      ripgrep
      fd
      jq
      btop
      htop
      openssh
      tree
      file
      rsync
      zip
      unzip
      p7zip
    ];

    programs.zsh.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;
  };
}
