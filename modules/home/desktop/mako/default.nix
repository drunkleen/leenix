{
  variables,
  ...
}:

{
  services.mako = {
    enable = variables.desktop.waybar;

    settings = {
      anchor = "top-right";
      background-color = "#0b1113";
      border-color = "#0b1113";
      border-size = 2;
      border-radius = 8;
      default-timeout = 5000;
      font = "JetBrainsMono Nerd Font 11";
      height = 100;
      icons = true;
      layer = "overlay";
      margin = 8;
      max-visible = 5;
      padding = 8;
      progress-color = "#4c6a6f";
      text-color = "#d8e3e0";
      width = 360;

      "urgency=low" = {
        border-color = "#4c6a6f";
        default-timeout = 3000;
      };

      "urgency=normal" = {
        border-color = "#4c6a6f";
      };

      "urgency=critical" = {
        border-color = "#a55555";
        default-timeout = 0;
      };
    };
  };
}
