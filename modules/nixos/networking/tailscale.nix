{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.leenix.networking.tailscale;
  inherit (lib) mkIf;
  # LEENIX DNS policy is authoritative. acceptDns=false (default) makes the
  # client reject tailnet/MagicDNS settings so they can never hijack the
  # resolver; a host may explicitly opt into true.
  dnsVal = if cfg.acceptDns then "true" else "false";
in
{
  # Universal LEENIX Tailscale client. Runtime identity/state is owned by
  # tailscaled; we never run `tailscale up` imperatively or embed auth
  # keys/secrets. Exit nodes, subnet routing and advertisement are host policy.
  #
  # DNS ownership: the reconciliation unit below applies the client preference
  # with `tailscale set --accept-dns=...` — the official mechanism that changes
  # ONLY the DNS preference. It never re-runs the full `tailscale up` flow, so
  # it does not re-authenticate and cannot alter routes, exit-node selection,
  # advertised routes, hostname or any other preference. It requires no auth
  # key, is idempotent, and tolerates a logged-out/uninitialized node.
  config = mkIf cfg.enable {
    services.tailscale = {
      enable = true;
      # Applies on a fresh `tailscale up`; the reconciliation unit enforces the
      # same preference on an already-configured node.
      extraUpFlags = [ "--accept-dns=${dnsVal}" ];
    };

    systemd.services.tailscale-acceptdns = {
      description = "LEENIX Tailscale DNS preference (accept-dns=${dnsVal})";
      wantedBy = [ "multi-user.target" ];
      after = [ "tailscaled.service" ];
      requires = [ "tailscaled.service" ];
      # Skip cleanly when the daemon socket is absent (tailscaled not up).
      unitConfig.ConditionPathExists = "/run/tailscale/tailscaled.sock";

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "leenix-tailscale-acceptdns" ''
          # Wait (bounded) for the local daemon API to be ready. Never fail the
          # unit/boot: a logged-out or uninitialized node simply exits 0.
          for i in 1 2 3 4 5; do
            if ${lib.getExe pkgs.tailscale} set --accept-dns=${dnsVal} 2>/dev/null; then
              # Regenerate resolver state only where keys can go stale in this
              # resolvconf architecture (openresolv exclusive_interfaces).
              if [ -x ${pkgs.openresolv}/bin/resolvconf ]; then
                ${pkgs.openresolv}/bin/resolvconf -u 2>/dev/null || true
              fi
              exit 0
            fi
            ${pkgs.coreutils}/bin/sleep 1
          done
          exit 0
        '';
      };
    };
  };
}
