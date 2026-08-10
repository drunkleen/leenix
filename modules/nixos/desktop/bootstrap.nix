{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.leenix.bootstrap;

  browserPackage = pkgs.${cfg.browser};
  editorPackage = pkgs.${cfg.editor};
  wifiPackage = pkgs.${cfg.wifi};
  bluetoothPackage = pkgs.${cfg.bluetooth};
  audioPackage = pkgs.${cfg.audio};
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      browserPackage
      editorPackage
      wifiPackage
      bluetoothPackage
      audioPackage

      pkgs.kitty
      pkgs.wl-clipboard
    ];

    # Audio
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # Wi-Fi
    networking.wireless.iwd.enable = true;

    # Desktop plumbing
    services.dbus.enable = true;
  };
}
