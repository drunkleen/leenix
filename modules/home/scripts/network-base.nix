{ ... }:

{
  # Universal network management: DNS policy and Tailscale baseline control.
  # Tailscale is a universal base capability; DNS is host policy. No Wi-Fi,
  # Bluetooth or VPN scripts here — those are capability-gated groups.
  imports = [
    ./leenix-config-dns.nix
    ./leenix-network-tailscale.nix
  ];
}
