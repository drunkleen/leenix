{
  config,
  lib,
  ...
}:

let
  dns = config.leenix.networking.dns;
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
    (lib.mkIf (dns.mode == "custom") {
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
  ];
}
