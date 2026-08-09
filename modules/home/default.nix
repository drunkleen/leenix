{ ... }:

{
  imports = [
    ./apps
    ./cli
    ./git
    ./hyprland
    ./nvim
    ./scripts
    ./shell
    ./ssh
  ];

  targets.genericLinux = {
    enable = true;
  };
}
