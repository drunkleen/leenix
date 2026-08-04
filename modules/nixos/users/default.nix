{ pkgs, ... }:

{
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
}
