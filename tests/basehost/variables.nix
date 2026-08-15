{
  architecture = "x86_64-linux";

  host = {
    hostname = "basehost";
  };

  user = {
    username = "baseuser";
    homeDirectory = "/home/baseuser";
    extraGroups = [ "wheel" ];
  };

  timezone = "UTC";

  locale = {
    language = "en_US.UTF-8";
    region = "en_US.UTF-8";
  };

  keyboard.layouts = [ "us" ];

  profiles = {
    base = true;
  };

  # Minimal desktop capability attr so the shared home modules evaluate; the
  # actual base profile enables no desktop feature (hyprland=false etc.).
  desktop = {
    environment = "";
    hyprland = false;
    waybar = false;
    hyprlock = false;
    hypridle = false;
    hyprsunset = false;
  };
}
