{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.networking.openvpn;
  inherit (lib) mkIf mkOption types mapAttrs;
in

{
  # Reusable, declarative-first OpenVPN capability. Host policy declares
  # profiles under leenix.networking.openvpn.profiles; the NixOS openvpn module
  # generates openvpn-<name>.service units. Connections are menu-managed and
  # never auto-started by default.
  #
  # Credentials (auth-user-pass) are referenced by an absolute file path
  # (authUserPassFile) outside the repository — never committed secrets.
  options.leenix.networking.openvpn = {
    enable = lib.mkEnableOption "declarative OpenVPN profiles";

    profiles = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          config = mkOption {
            type = types.lines;
            description = "OpenVPN configuration lines (may use `config /path/to/file.ovpn`).";
          };

          authUserPassFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Absolute path to an auth-user-pass credential file (outside the repo).";
          };

          autoStart = mkOption {
            type = types.bool;
            default = false;
            description = "Whether the profile starts automatically at boot. Defaults to off (menu-managed).";
          };

          updateResolvConf = mkOption {
            type = types.bool;
            default = false;
            description = "Update resolv.conf with DNS provided by the profile.";
          };
        };
      });
      default = { };
      description = "Declarative OpenVPN profiles (host policy).";
    };
  };

  config = mkIf (cfg.enable || cfg.profiles != { }) {
    services.openvpn.servers = mapAttrs (
      name: p:
      {
        config = p.config;
        autoStart = p.autoStart;
        updateResolvConf = p.updateResolvConf;
        authUserPass = if p.authUserPassFile != null then p.authUserPassFile else null;
      }
    ) cfg.profiles;
  };
}
