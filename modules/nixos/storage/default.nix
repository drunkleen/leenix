{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  services.fstrim.enable = true;
}
