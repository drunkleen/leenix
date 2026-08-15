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
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit variables;

      browser = "firefox";
      mediaPlayer = "mpv";
      imageViewer = "imv";
      documentViewer = "zathura";
      musicPlayer = "cliamp";
      themeMode = "dark";
      localeLanguage = "en_US.UTF-8";
      localeRegion = "en_US.UTF-8";
    };

    users.${variables.user.username} = import ../../home;
  };

  system.stateVersion = "26.05";
}
