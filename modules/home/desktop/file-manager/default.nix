{ fileManager, ... }:

{
  imports = [
    (if fileManager == "dolphin" then ./dolphin.nix else ./nautilus.nix)
  ];
}
