{ musicPlayer, ... }:

{
  imports = [
    {
      cliamp = ./cliamp.nix;
    }.${musicPlayer}
  ];
}
