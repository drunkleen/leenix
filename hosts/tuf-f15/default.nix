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

    ../../modules/nixos/boot/limine
    ../../modules/nixos/boot/plymouth.nix
    ../../modules/nixos/disk/default.nix

    ./hardware-configuration.nix
  ];

  # Windows dual boot: Windows Boot Manager lives on a separate ESP
  # (nvme0n1p3, GPT GUID 8adec9ed-2e11-4ca8-9cd5-8626d8733170). Chainload it
  # from Limine so Windows stays bootable alongside NixOS generations.
  boot.loader.limine.extraEntries = ''
    /Windows
        protocol: efi
        path: guid(8adec9ed-2e11-4ca8-9cd5-8626d8733170):/EFI/Microsoft/Boot/bootmgfw.efi
  '';

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit variables;

      browser = config.leenix.desktop.browser;
      mediaPlayer = config.leenix.desktop.mediaPlayer;
      imageViewer = config.leenix.desktop.imageViewer;
      documentViewer = config.leenix.desktop.documentViewer;
      musicPlayer = config.leenix.desktop.musicPlayer;
      themeMode = config.leenix.theme.mode;
    };

    users.${variables.user.username} = import ../../home;
  };

  system.stateVersion = "26.05";
}
