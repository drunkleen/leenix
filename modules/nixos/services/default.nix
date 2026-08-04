{ pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

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
}
