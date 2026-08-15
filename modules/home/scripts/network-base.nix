{ ... }:

{
  # Universal network management: DNS policy and Tailscale baseline control.
  # Tailscale is a universal base capability; DNS is host policy. No Wi-Fi,
  # Bluetooth or VPN scripts here — those are capability-gated groups.
  #
  # leenix-tailscale-send is intentionally NOT here: it uses Walker and a file
  # picker, so it is a DESKTOP capability and lives in the desktop group.
  imports = [
    ./leenix-config-dns.nix
    ./leenix-ssh.nix
    ./leenix-network-tailscale.nix
  ];
}
