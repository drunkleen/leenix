{ ... }:

{
  imports = [
    ./cli
    ./git
    ./hyprland
    ./nvim
    ./shell
    ./ssh
  ];

  targets.genericLinux = {
    enable = true;
  };
}
