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

  timezone = "Europe/Berlin";

  locale = {
    language = "en_US.UTF-8";
    region = "de_DE.UTF-8";
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

  cursor = {
    theme = "capitaine-cursors";
    size = 36;
  };

  profiles = {
    base = true;
    desktop = true;
    laptop = true;

    gaming = true;
    development = false;
    hardened = false;
    server = false;
  };

  bootstrap = {
    enable = true;

    editor = "vscode";

    wifi = "impala";
    bluetooth = "bluetui";
    audio = "wiremix";
  };

  desktop = {
    environment = "hyprland";

    autologin = {
      enable = true;
    };

    uwsm = {
      enable = true;
    };

    hyprland = true;
    waybar = true;
    hyprlock = true;
    hypridle = true;
    hyprsunset = true;

    browser = "firefox";
    mediaPlayer = "mpv";
    imageViewer = "imv";
    documentViewer = "zathura";
    musicPlayer = "cliamp";
  };

  theme = {
    mode = "dark";
  };

  boot = {
    plymouth = {
      enable = true;
    };
  };

  hardware = {
    asus = true;
    intel = true;

    nvidia = {
      enable = true;
    };

    bluetooth = true;

    power-profiles = true;
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

    dns = {
      mode = "system";
      servers = [ ];
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
