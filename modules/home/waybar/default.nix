{ pkgs, ... }:

{
  imports = [
    ./config.nix
  ];

  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;

      targets = [
        "graphical-session.target"
      ];
    };

    style = ''
      @define-color foreground #d8e3e0;
      @define-color background #0b1113;
      @define-color critical #e16f73;

      * {
        background-color: @background;
        color: @foreground;

        border: none;
        border-radius: 0;
        min-height: 0;

        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      .modules-left {
        margin-left: 8px;
      }

      .modules-right {
        margin-right: 8px;
      }

      #workspaces button {
        all: initial;
        padding: 0 6px;
        margin: 0 1.5px;
        min-width: 9px;

        color: @foreground;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
      }

      #workspaces button.empty {
        opacity: 0.5;
      }

      #workspaces button.active {
        color: @foreground;
      }

      #workspaces button.urgent {
        color: @critical;
      }

      #cpu,
      #battery,
      #wireplumber,
      #custom-leenium {
        min-width: 12px;
        margin: 0 7.5px;
      }

      #tray {
        margin-right: 16px;
      }

      #bluetooth {
        margin-right: 17px;
      }

      #network {
        margin-right: 13px;
      }

      #custom-expand-icon {
        margin-right: 18px;
      }

      #clock {
        margin-left: 8.75px;
      }

      tooltip {
        padding: 2px;
        background-color: @background;
        color: @foreground;
      }

      #battery.warning {
        color: #d9c76b;
      }

      #battery.critical {
        color: @critical;
      }

      #wireplumber.muted {
        opacity: 0.5;
      }

      .tray-group-item {
        margin-right: 12px;
      }
    '';
  };

  home.packages = with pkgs; [
    pwvucontrol
    btop
  ];
}