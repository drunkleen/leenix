{ leenix, ... }:

{
  imports = [
    {
      cliamp = ./cliamp.nix;
    }.${leenix.desktop.musicPlayer}
  ];
}
