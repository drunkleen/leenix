{ pkgs, vars, ... }:

{
  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.fullName;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.bashInteractive;
  };

  security.sudo.wheelNeedsPassword = true;
}
