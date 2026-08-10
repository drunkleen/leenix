{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.boot.plymouth.enable {
    boot.plymouth.enable = true;
  };
}
