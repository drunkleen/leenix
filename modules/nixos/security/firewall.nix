{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.security.firewall;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    concatStringsSep
    optional
    filter
    ;
  hasColon = s: builtins.match ".*:.*" s != null;

  portSet = r:
    if builtins.length r.ports == 1 then
      builtins.toString (builtins.head r.ports)
    else
      "{ ${concatStringsSep ", " (map builtins.toString r.ports)} }";

  ifaceClause = r:
    if r.interfaces == [ ] then
      ""
    else if builtins.length r.interfaces == 1 then
      "iifname ${builtins.head r.interfaces} "
    else
      "iifname { ${concatStringsSep ", " (map (i: "\"${i}\"") r.interfaces)} } ";

  mkLine = family: srcs: iface: r:
    iface
    + (if srcs == [ ] then
      ""
    else if builtins.length srcs == 1 then
      (if family == "v4" then "ip saddr ${builtins.head srcs} " else "ip6 saddr ${builtins.head srcs} ")
    else
      (if family == "v4" then "ip saddr { ${concatStringsSep ", " srcs} } " else "ip6 saddr { ${concatStringsSep ", " srcs} } "))
    + "${r.protocol} dport ${portSet r} accept";

  # A rule with no sources applies to all addresses (both families); a rule
  # with sources is split per address family so IPv4 and IPv6 CIDRs match their
  # own saddr keyword.
  ruleLines = r:
    let
      iface = ifaceClause r;
      v4 = filter (s: !hasColon s) r.sources;
      v6 = filter (s: hasColon s) r.sources;
    in
    if r.sources == [ ] then
      [ (mkLine "both" [ ] iface r) ]
    else
      (optional (v4 != [ ]) (mkLine "v4" v4 iface r))
      ++ (optional (v6 != [ ]) (mkLine "v6" v6 iface r));

  allRules = concatStringsSep "\n" (lib.concatMap ruleLines cfg.rules);
in

{
  # Universal declarative firewall. Implemented on the native NixOS firewall
  # with the nftables backend — no UFW, no imperative rule mutation. Default
  # input policy is drop; only `rules` explicitly accept source-scoped traffic.
  options.leenix.security.firewall = {
    enable = mkEnableOption "declarative LEENIX firewall (nftables)";

    rules = mkOption {
      type = types.listOf (types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            description = "Rule name (informational).";
          };

          protocol = mkOption {
            type = types.enum [
              "tcp"
              "udp"
            ];
            description = "Transport protocol.";
          };

          ports = mkOption {
            type = types.listOf types.port;
            description = "Destination ports on this host.";
          };

          sources = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Source IPs/CIDRs (IPv4 or IPv6). A bare host like 10.42.0.3 means only that host; 10.42.0.0/24 means that subnet; 0.0.0.0/0 / ::/0 mean all addresses and must be explicit. Empty means all sources — use deliberately.";
          };

          interfaces = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Optional ingress interfaces (e.g. tailscale0).";
          };
        };
      });
      default = [ ];
      description = "Declarative inbound firewall rules (host policy).";
    };
  };

  config = mkIf (cfg.enable || cfg.rules != [ ]) {
    networking.firewall.enable = true;
    networking.nftables.enable = true;

    # The nftables backend appends these to the input-allow chain, evaluated
    # for new connections before the input chain's drop policy.
    networking.firewall.extraInputRules = allRules;
  };
}
