{
  config,
  variables,
  ...
}:

{
  imports = [
    ../../modules/nixos/core/options.nix
    ../../modules/nixos/core/host.nix

    ../../profiles/base.nix
    ../../profiles/desktop.nix
    ../../profiles/laptop.nix

    ../../modules/nixos/boot/systemd-boot.nix
    ../../modules/nixos/boot/plymouth.nix
    ../../modules/nixos/disk/default.nix

    ./hardware-configuration.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit variables;

      fileManager = config.leenix.desktop.fileManager;
      browser = config.leenix.desktop.browser;
      themeMode = config.leenix.theme.mode;
    };

    users.${variables.user.username} = import ../../home;
  };

  system.stateVersion = "26.05";
}
