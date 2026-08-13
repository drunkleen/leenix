{
  config,
  lib,
  ...
}:

{
  # Universal LEENIX Podman container baseline. No Docker daemon, no exposed
  # ports, no containers, no registry/auth configuration. Docker CLI
  # compatibility and the socket are deliberately NOT enabled by default.
  #
  # Socket policy: the pinned virtualisation.podman module enables the system
  # podman API socket unconditionally (systemd.sockets.podman.wantedBy =
  # sockets.target). There is no virtualisation.podman.socket.enable option, so
  # we override the standard systemd.sockets option with a higher priority to
  # keep the socket unit installed but NOT auto-started. Rootless Podman CLI
  # (podman run/info) does not require the API socket. The same applies to the
  # per-user socket: it stays available for manual `systemctl --user start`
  # but is not auto-enabled.
  config = lib.mkIf config.leenix.services.podman.enable {
    virtualisation.podman.enable = true;

    systemd.sockets.podman.wantedBy = lib.mkForce [ ];
    systemd.user.sockets.podman.wantedBy = lib.mkForce [ ];
  };
}
