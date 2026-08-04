{ pkgs, vars, ... }:

{
  programs.zsh.enable = true;

  users.users.${vars.username} = {
    isNormalUser = true;
    description = vars.fullName;

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = true;
}
