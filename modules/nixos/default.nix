_:

{
  imports = [
    ../../profiles/core.nix
    ./boot
    ../../profiles/desktop.nix
    ./hardware
    ./networking
    ./security
    ./services
    ./storage
    ./users
  ];
}
