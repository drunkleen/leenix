{
  hostname = "tuf-f15";
  system = "x86_64-linux";

  username = "snape";
  fullName = "Snape";

  git = {
    name = "DrunkLeen";
    email = "snape@drunkleen.com";
    defaultBranch = "master";
  };

  timezone = "Europe/Berlin";
  locale = "en_US.UTF-8";
  keymap = "us";

  hardware.nvidia.prime = {
    intelBusId = "PCI:0@0:2:0";
    nvidiaBusId = "PCI:1@0:0:0";
  };
}
