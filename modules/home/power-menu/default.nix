{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wlogout
  ];

  xdg.configFile."wlogout/layout".text = ''
    {
      "label": "lock",
      "action": "loginctl lock-session",
      "text": "Lock",
      "keybind": "l"
    }
    {
      "label": "logout",
      "action": "hyprctl dispatch exit",
      "text": "Logout",
      "keybind": "e"
    }
    {
      "label": "suspend",
      "action": "systemctl suspend",
      "text": "Suspend",
      "keybind": "s"
    }
    {
      "label": "reboot",
      "action": "systemctl reboot",
      "text": "Reboot",
      "keybind": "r"
    }
    {
      "label": "shutdown",
      "action": "systemctl poweroff",
      "text": "Shutdown",
      "keybind": "p"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
    @define-color background #0b1113;
    @define-color surface #11191c;
    @define-color border #223033;
    @define-color foreground #d8e3e0;
    @define-color accent #33b8a8;
    @define-color accent-soft #59d6c5;
    @define-color danger #e16f73;

    * {
      background-image: none;
      box-shadow: none;
      font-family: "JetBrainsMono Nerd Font";
      font-size: 18px;
    }

    window {
      background-color: alpha(@background, 0.92);
    }

    button {
      margin: 12px;
      padding: 24px;

      color: @foreground;
      background-color: alpha(@surface, 0.96);

      border: 2px solid @border;
      border-radius: 0;

      background-repeat: no-repeat;
      background-position: center;
      background-size: 25%;
    }

    button:focus,
    button:hover {
      color: @background;
      background-color: @accent;
      border-color: @accent-soft;
      outline-style: none;
    }

    #lock {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/lock.png"));
    }

    #logout {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/logout.png"));
    }

    #suspend {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/suspend.png"));
    }

    #reboot {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/reboot.png"));
    }

    #shutdown {
      background-image: image(url("${pkgs.wlogout}/share/wlogout/icons/shutdown.png"));
    }

    #shutdown:hover,
    #shutdown:focus {
      color: @foreground;
      background-color: @danger;
      border-color: @danger;
    }
  '';
}