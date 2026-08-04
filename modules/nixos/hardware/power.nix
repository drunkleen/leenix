{ pkgs, ... }:

{
  services.power-profiles-daemon.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };

  environment.systemPackages = with pkgs; [
    powertop
  ];
}
