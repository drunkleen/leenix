{ pkgs, ... }:

{
  imports = [
    ./nix-maintenance.nix
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      PermitEmptyPasswords = false;
      X11Forwarding = false;
      PrintMotd = false;

      AuthenticationMethods = "publickey";
    };
  };

  services.tailscale.enable = true;
}
