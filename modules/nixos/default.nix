_:

{
  imports = [
    ../../profiles/core.nix
    ./boot
    ../../profiles/desktop.nix
    ../../profiles/laptop.nix
    ./networking
    ./security
    ./services
    ./storage
    ./users
  ];
}
