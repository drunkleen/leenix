{
  architecture = "x86_64-linux";

  host = {
    hostname = "tuf-f15";
  };

  user = {
    username = "snape";
    homeDirectory = "/home/snape";

    extraGroups = [
      "wheel"
      "video"
      "audio"
      "input"
      "gamemode"
    ];
  };

  git = {
    name = "DrunkLeen";
    email = "snape@drunkleen.com";
    branch = "master";
  };
}
