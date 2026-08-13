{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.networking.wireguard;
  inherit (lib)
    mkIf
    mkOption
    types
    ;
in

{
  # Reusable, declarative-first WireGuard capability. Host policy declares
  # interfaces under leenix.networking.wireguard.interfaces; the NixOS
  # wireguard module generates wg-quick systemd units (wireguard-<iface>).
  #
  # Private keys and preshared keys are ALWAYS file references (privateKeyFile /
  # presharedKeyFile) pointing outside the repository — never inline secrets.
  options.leenix.networking.wireguard = {
    enable = lib.mkEnableOption "declarative WireGuard interfaces";

    interfaces = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          ips = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "IP addresses assigned to this interface.";
          };

          privateKeyFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Absolute path to the interface private key file (outside the repo).";
          };

          listenPort = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "UDP listen port for the interface.";
          };

          peers = mkOption {
            type = types.listOf (types.submodule {
              options = {
                publicKey = mkOption {
                  type = types.str;
                  description = "Peer public key.";
                };

                endpoint = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Peer endpoint (host:port).";
                };

                allowedIPs = mkOption {
                  type = types.listOf types.str;
                  default = [ ];
                  description = "Allowed IPs routed to this peer.";
                };

                persistentKeepalive = mkOption {
                  type = types.nullOr types.int;
                  default = null;
                  description = "Persistent keepalive interval in seconds.";
                };

                presharedKeyFile = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "Absolute path to the preshared key file (outside the repo).";
                };
              };
            });
            default = [ ];
            description = "Peers for this interface.";
          };
        };
      });
      default = { };
      description = "Declarative WireGuard interfaces (host policy).";
    };
  };

  config = mkIf (cfg.enable || cfg.interfaces != { }) {
    networking.wireguard.interfaces = cfg.interfaces;
  };
}
