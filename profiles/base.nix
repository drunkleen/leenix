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
  ];

  config = lib.mkIf cfg.enable {
    networking.hostName = config.leenix.host.hostname;

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

    environment.systemPackages = with pkgs; [
      git
      curl
      wget
      vim
    ];

    programs.zsh.enable = true;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    nixpkgs.config.allowUnfree = true;
  };
}
