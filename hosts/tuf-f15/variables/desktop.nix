{
  cursor = {
    theme = "capitaine-cursors";
    size = 36;
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

    sddm = {
      enable = true;
      autologin = true;
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
}
