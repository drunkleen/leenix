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
  config = lib.mkIf cfg.enable {
    networking.hostName = config.leenix.host.hostname;

    time.timeZone = config.leenix.host.timezone;

    i18n = {
      defaultLocale = config.leenix.locale.default;
      extraLocaleSettings = config.leenix.locale.extra;
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
