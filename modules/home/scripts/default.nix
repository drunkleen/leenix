{
  lib,
  variables,
  ...
}:

let
  desktopCap = variables.profiles.desktop or false;
  laptopCap = variables.profiles.laptop or false;
  devCap = variables.profiles.development or false;
  cyberCap = variables.profiles.cybersecurity or false;
  hyprlandCap = variables.desktop.hyprland or false;
  asusModel = (variables.hardware or { }).asus.model or null;
  wifiCap = variables.networking.iwd or false;
  bluetoothCap = variables.hardware.bluetooth or false;
  wireguardConfigured = ((variables.networking or { }).wireguard.interfaces or { }) != { };
  openvpnConfigured = ((variables.networking or { }).openvpn.profiles or { }) != { };
in

{
  # Capability-based script composition. Groups are installed according to the
  # host's declared profiles/hardware/networking capabilities, never via
  # hostname checks.
  #
  #   base (always)     → core, system, network-base, tools
  #   iwd Wi-Fi cap     → + network-wifi
  #   Bluetooth cap     → + network-bluetooth
  #   WireGuard/OpenVPN → + network-vpn (only when profiles are configured)
  #   desktop profile   → + desktop, hardware
  #   development       → + dev
  #   cybersecurity     → + cybersecurity (wordlists + external-tool helpers)
  #   Hyprland cap      → + hyprland
  #   laptop profile    → + laptop
  #   ASUS model cap    → + only the detector matching hardware.asus.model
  #
  # A headless server or Raspberry Pi using only the base profile receives no
  # Wi-Fi/Bluetooth/VPN/desktop/hyprland/laptop/ASUS/development scripts.
  imports =
    [ ./core.nix ./system.nix ./network-base.nix ./tools.nix ]
    ++ lib.optionals wifiCap [ ./network-wifi.nix ]
    ++ lib.optionals bluetoothCap [ ./network-bluetooth.nix ]
    ++ lib.optionals (wireguardConfigured || openvpnConfigured) [ ./network-vpn.nix ]
    ++ lib.optionals (desktopCap || laptopCap) [ ./hardware.nix ]
    ++ lib.optionals desktopCap [ ./desktop.nix ]
    ++ lib.optionals devCap [ ./dev.nix ]
    ++ lib.optionals cyberCap [ ./cybersecurity.nix ]
    ++ lib.optionals hyprlandCap [ ./hyprland.nix ]
    ++ lib.optionals laptopCap [ ./laptop.nix ]
    ++ lib.optional (asusModel == "rog") ./leenix-hw-asus-rog.nix
    ++ lib.optional (asusModel == "expertbook-b9406") ./leenix-hw-asus-expertbook-b9406.nix
    ++ lib.optional (asusModel == "zenbook-ux5406aa") ./leenix-hw-asus-zenbook-ux5406aa.nix;
}
