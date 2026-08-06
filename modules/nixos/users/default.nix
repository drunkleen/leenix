{
  config,
  pkgs,
  vars,
  ...
}:

{
  programs.zsh.enable = true;

  users = {
    mutableUsers = false;

    users = {
      root.hashedPassword = "!";

      ${vars.username} = {
        isNormalUser = true;
        description = vars.fullName;
        hashedPasswordFile = config.age.secrets.user-password.path;

        extraGroups = [
          "networkmanager"
          "wheel"
        ];

        shell = pkgs.zsh;
      };
    };
  };

  security.sudo.wheelNeedsPassword = true;
}
