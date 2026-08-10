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
    ];
  };

  git = {
    name = "DrunkLeen";
    email = "snape@drunkleen.com";
    branch = "master";
  };

  timezone = "Europe/Berlin";

  locale = {
    default = "en_US.UTF-8";

    extra = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  keyboard = {
    layouts = [
      "us"
      "ir"
    ];

    options = [
      "grp:alt_shift_toggle"
    ];
  };

  profiles = {
    base = true;
    desktop = true;
    laptop = true;

    gaming = false;
    development = false;
    hardened = false;
    server = false;
  };

  bootstrap = {
    enable = true;

    browser = "firefox";
    editor = "vscode";

    wifi = "impala";
    bluetooth = "bluetui";
    audio = "wiremix";
  };

  desktop = {
    environment = "hyprland";

    hyprland = true;
    waybar = false;
    hyprlock = false;
    hypridle = false;
    hyprsunset = false;
  };

  hardware = {
    asus = true;
    intel = true;

    nvidia = {
      enable = true;
    };

    bluetooth = true;
  };

  disk = {
    device = "/dev/nvme0n1";
    layout = "laptop-luks-btrfs";
  };

  memory = {
    zram = true;
    hibernate = false;
  };

  networking = {
    iwd = true;

    ssh = {
      enable = false;
    };
  };

  security = {
    pam = {
      enable = true;
    };

    fido2 = {
      enable = false;
      userPresence = true;
      userVerification = false;
      pinVerification = true;
    };
  };
}
