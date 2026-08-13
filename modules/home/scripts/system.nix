{ ... }:

{
  # System lifecycle scripts: power/session control, hibernation, drives,
  # snapshots. Headless-safe; usable from base profile.
  imports = [
    ./leenix-drive-info.nix
    ./leenix-drive-select.nix
    ./leenix-hibernation-available.nix
    ./leenix-hibernation-remove.nix
    ./leenix-hibernation-setup.nix
    ./leenix-snapshot.nix
    ./leenix-system-lock.nix
    ./leenix-system-logout.nix
    ./leenix-system-reboot.nix
    ./leenix-system-shutdown.nix
    ./leenix-system-wake.nix
    ./leenix-toggle-suspend.nix
  ];
}
