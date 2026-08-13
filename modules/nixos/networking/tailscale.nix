{
  config,
  lib,
  ...
}:

{
  # Universal LEENIX Tailscale client. Runtime identity/state is owned by
  # tailscaled; we never run `tailscale up` or embed auth keys/secrets.
  # Exit nodes, subnet routing and advertisement are host policy, not baseline.
  config = lib.mkIf config.leenix.networking.tailscale.enable {
    services.tailscale.enable = true;
  };
}
