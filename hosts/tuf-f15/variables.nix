{
  hostname = "tuf-f15";
  system = "x86_64-linux";

  username = "snape";
  fullName = "Snape";

  sshAuthorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH/aDWq4qLWzSFn+Zqt6FBIN+mFAR9hMG2dRHkweLxAO snape@tuf-f15"
  ];

  git = {
    name = "DrunkLeen";
    email = "snape@drunkleen.com";
    defaultBranch = "master";
  };

  timezone = "Europe/Berlin";
  locale = "en_US.UTF-8";
  keymap = "us";

  hardware = {
    cpu.intel.enable = true;
    touchpad.device = "asup1205:00-093a:2003-touchpad";

    nvidia = {
      enable = true;

      prime = {
        intelBusId = "PCI:0@0:2:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
  };
}
