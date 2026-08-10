{ ... }:

{
  imports = [
    ./leenix-brightness-display-apple.nix
    ./leenix-config-direct-boot.nix
    ./leenix-drive-password.nix
    ./leenix-first-run.nix
    ./leenix-install-dev-env.nix
    ./leenix-install-docker-dbs.nix
    ./leenix-install-gaming-lutris.nix
    ./leenix-install-gaming-xbox-controllers.nix
    ./leenix-install-once.nix
    ./leenix-install-tailscale.nix
    ./leenix-remove-browser.nix
    ./leenix-remove-gaming-xbox-controllers.nix
    ./leenix-remove-security-fido2.nix
    ./leenix-remove-security-fingerprint.nix
    ./leenix-restart-trackpad.nix
    ./leenix-setup-dns.nix
    ./leenix-setup-security-fido2.nix
    ./leenix-setup-security-fingerprint.nix
    ./leenix-sudo-keepalive.nix
    ./leenix-sudo-passwordless.nix
    ./leenix-sudo-reset.nix
    ./leenix-theme-set-browser.nix
    ./leenix-toggle-hybrid-gpu.nix
    ./leenix-tz-select.nix
    ./leenix-update-firmware.nix
    ./leenix-update-time.nix
    ./leenix-windows-vm.nix
  ];
}
