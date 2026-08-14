{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.networking.ssh;
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
in

{
  # Reusable, declarative OpenSSH server capability. `enable` controls whether
  # the sshd service exists; `autoStart` controls whether it starts at boot.
  # enable=true + autoStart=false keeps the sshd unit installed but not wanted
  # by multi-user.target, so `sudo systemctl start sshd` works manually.
  # openFirewall is forced off: port exposure is owned by LEENIX firewall
  # policy (leenix.security.firewall), never implicitly by sshd.
  options.leenix.networking.ssh = {
    enable = mkEnableOption "OpenSSH server (sshd)";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = "Start sshd automatically at boot. False keeps the unit installed but inactive until started manually.";
    };

    port = mkOption {
      type = types.port;
      default = 22;
      description = "SSH listen port.";
    };

    passwordAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Allow password authentication. Defaults to off (key-based only).";
    };

    keyboardInteractiveAuthentication = mkOption {
      type = types.bool;
      default = false;
      description = "Allow keyboard-interactive (PAM challenge/response) authentication. Off by default; ordinary password login uses PasswordAuthentication.";
    };

    permitRootLogin = mkOption {
      type = types.enum [
        "yes"
        "no"
        "prohibit-password"
      ];
      default = "no";
      description = "Permit root logins over SSH. Defaults to no.";
    };

    allowedUsers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Users that receive authorized_keys from `publicKeys`.";
    };

    publicKeys = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Public SSH keys (authorized_keys) granted to `allowedUsers`. Public keys only; private keys/secrets never belong in the repo.";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PasswordAuthentication = cfg.passwordAuthentication;
        KbdInteractiveAuthentication = cfg.keyboardInteractiveAuthentication;
        PermitRootLogin = cfg.permitRootLogin;
      };
      openFirewall = false;
    };

    users.users = lib.genAttrs cfg.allowedUsers (u: {
      openssh.authorizedKeys.keys = cfg.publicKeys;
    });

    # The pinned openssh module unconditionally sets
    # systemd.services.sshd.wantedBy = [ "multi-user.target" ] and offers no
    # autoStart option (startWhenNeeded is socket activation, which we must not
    # use). The cleanest declarative way to keep the unit present but not
    # started at boot is a higher-priority wantedBy override.
    systemd.services.sshd.wantedBy = mkIf (!cfg.autoStart) (lib.mkForce [ ]);
  };
}
