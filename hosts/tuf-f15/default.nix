{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usb_storage"
    "sd_mod"
  ];

  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  networking.hostName = "tuf-f15";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    keyMap = "us";
  };

  users.users.snape = {
    isNormalUser = true;
    description = "Snape";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.bashInteractive;
  };

  security.sudo.wheelNeedsPassword = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    pciutils
    usbutils
  ];

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.tailscale.enable = true;


  services.fstrim.enable = true;

  system.stateVersion = "26.05";
}
