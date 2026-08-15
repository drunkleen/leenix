{
  config,
  lib,
  pkgs,
  ...
}:

let
  dns = config.leenix.networking.dns;
  inherit (lib) mkIf;
in
{
  config = lib.mkMerge [
    {
      # custom mode requires at least one explicit DNS server.
      assertions = [
        {
          assertion = dns.mode != "custom" || dns.servers != [ ];
          message = "leenix.networking.dns: custom mode requires at least one server in networking.dns.servers";
        }
      ];
    }

    # Custom mode: the resolver gets ONLY networking.dns.servers, in order.
    # DHCP-provided DNS is suppressed (dhcpcd's resolv.conf hook) while DHCP
    # address/gateway/routes configuration continues unchanged. System mode sets
    # nothing, so normal DHCP DNS semantics are restored.
    (mkIf (dns.mode == "custom") {
      networking.nameservers = dns.servers;
      networking.dhcpcd.extraConfig = lib.mkDefault ''
        nohook resolv.conf
      '';
      # openresolv: mark the `static` key exclusive so resolver generation uses
      # ONLY the static (custom) nameservers. This makes custom DNS take effect
      # immediately even if stale DHCP resolvconf keys (e.g. *.dhcp / *.ra)
      # remain stored after switching from System mode; it also means those
      # DHCP keys never need manual deletion for normal operation.
      networking.resolvconf.extraConfig = lib.mkDefault ''
        exclusive_interfaces="static"
      '';
    })

    # NixOS registers the openresolv `static` key only at boot (via
    # networking.localCommands), so a live `switch` leaves /etc/resolv.conf
    # stale. This oneshot re-registers the key from the CURRENT
    # networking.nameservers and regenerates resolv.conf on every boot AND every
    # switch, making DNS changes take effect immediately. It runs in both modes
    # so switching custom->system clears the stale static key and restores DHCP
    # semantics.
    (mkIf config.networking.resolvconf.enable {
      systemd.services.leenix-dns-resolvconf = {
        description = "Register static LEENIX DNS servers with openresolv";
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "leenix-dns-resolvconf" (
            let
              rc = "${pkgs.openresolv}/bin/resolvconf";
              nameservers = lib.concatMapStringsSep "\n" (ns: "nameserver ${ns}") config.networking.nameservers;
            in
            ''
              # Reconcile the openresolv `static` key with the current
              # networking.nameservers, then regenerate /etc/resolv.conf. Never
              # fail the unit/boot: absent resolvconf just exits 0.
              if [ -x ${rc} ]; then
                if [ -n "${nameservers}" ]; then
                  printf '%s\n' "${nameservers}" | ${rc} -m 1 -a static
                else
                  ${rc} -d static
                fi
                ${rc} -u
              fi
            ''
          );
        };
      };
    })
  ];
}
