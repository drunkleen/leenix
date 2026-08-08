{ ... }:

{
  imports = [
    ./cli
    ./git
    ./nvim
    ./shell
    ./ssh
  ];

  targets.genericLinux = {
    enable = true;
  };
}
