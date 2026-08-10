{ variables, ... }:

{
  leenix = {
    host = {
      hostname = variables.host.hostname;
      architecture = variables.architecture;
      timezone = variables.timezone;
    };

    user = {
      username = variables.user.username;
      homeDirectory = variables.user.homeDirectory;
      extraGroups = variables.user.extraGroups;
    };

    git = {
      name = variables.git.name;
      email = variables.git.email;
      branch = variables.git.branch;
    };

    locale = {
      default = variables.locale.default;
      extra = variables.locale.extra;
    };

    keyboard = {
      layouts = variables.keyboard.layouts;
      options = variables.keyboard.options;
    };

    cursor = {
      theme = variables.cursor.theme;
      size = variables.cursor.size;
    };

    boot = {
      plymouth.enable = variables.boot.plymouth.enable;
    };

    profiles = {
      base.enable = variables.profiles.base;
      desktop.enable = variables.profiles.desktop;
      laptop.enable = variables.profiles.laptop;
      gaming.enable = variables.profiles.gaming;
      development.enable = variables.profiles.development;
      hardened.enable = variables.profiles.hardened;
      server.enable = variables.profiles.server;
    };

    bootstrap = {
      enable = variables.bootstrap.enable;
      browser = variables.bootstrap.browser;
      editor = variables.bootstrap.editor;
      wifi = variables.bootstrap.wifi;
      bluetooth = variables.bootstrap.bluetooth;
      audio = variables.bootstrap.audio;
    };

    desktop = {
      environment = variables.desktop.environment;

      hyprland.enable = variables.desktop.hyprland;
      waybar.enable = variables.desktop.waybar;
      hyprlock.enable = variables.desktop.hyprlock;
      hypridle.enable = variables.desktop.hypridle;
      hyprsunset.enable = variables.desktop.hyprsunset;

      autologin.enable = variables.desktop.autologin.enable;

      uwsm.enable = variables.desktop.uwsm.enable;
    };

    hardware = {
      asus.enable = variables.hardware.asus;
      intel.enable = variables.hardware.intel;
      nvidia.enable = variables.hardware.nvidia.enable;
      bluetooth.enable = variables.hardware.bluetooth;
    };

    disk = {
      device = variables.disk.device;
      layout = variables.disk.layout;
    };

    memory = {
      zram.enable = variables.memory.zram;
      hibernate.enable = variables.memory.hibernate;
    };

    networking = {
      iwd.enable = variables.networking.iwd;
      ssh.enable = variables.networking.ssh.enable;
    };

    security = {
      pam.enable = variables.security.pam.enable;

      fido2 = {
        enable = variables.security.fido2.enable;
        userPresence = variables.security.fido2.userPresence;
        userVerification = variables.security.fido2.userVerification;
        pinVerification = variables.security.fido2.pinVerification;
      };
    };
  };
}
