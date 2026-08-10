{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.memory.zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
    };
  };
}
