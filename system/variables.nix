{
  system = "x86_64-linux";

  host = {
    hostname = "hogwarts";
  };

  user = {
    username = "snape";
    homeDirectory = "/home/snape";
  };

  git = {
    name = "DrunkLeen";
    email = "snape@drunkleen.com";
    branch = "master";
  };

  yubikey = {
    authFile = "/home/snape/.config/Yubico/u2f_keys";
    userPresence = true;
    userVerification = false;
    pinVerification = true;
  };

  boot = {
    luks = {
      device = "/dev/nvme0n1p2";
      uuid = "8da1c3c9-5ee6-4961-b935-4a3d76a6b0f0";
      mapperName = "root";
    };

    fido2 = {
      device = "auto";
    };

    root = {
      zswap = false;
      flags = "subvol=@";
      readWrite = true;
      fsType = "btrfs";
    };
  };

}
