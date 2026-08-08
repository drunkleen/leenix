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
}
