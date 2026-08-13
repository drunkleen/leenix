{ ... }:

{
  # VPN management scripts: runtime control of declaratively-configured
  # WireGuard interfaces and OpenVPN profiles. Installed only when the host
  # declares such profiles (variables.networking.wireguard / openvpn).
  imports = [
    ./leenix-network-openvpn.nix
    ./leenix-network-wireguard.nix
  ];
}
