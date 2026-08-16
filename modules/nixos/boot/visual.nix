{
  config,
  lib,
  ...
}:

# LEENIX quiet boot visuals.
#
# Owns ONLY presentation concerns:
#   - quiet/status/cursor kernel params
#   - console log level
#   - verbose/recovery override
#
# Plymouth display-manager coordination is stock NixOS (plymouth-quit /
# plymouth-quit-wait are wanted by multi-user.target; the display manager owns
# the graphical VT). Kernel SELECTION policy lives in
# modules/nixos/boot/kernel.nix. Plymouth enablement/theme/LUKS integration
# lives in modules/nixos/boot/plymouth.nix.

let
  cfg = config.leenix.boot.visual;

  quietParams = [
    # Suppress normal kernel console chatter (errors still print).
    "quiet"
    # Hide stage-2 systemd status lines on the console during a healthy boot.
    "systemd.show_status=auto"
    # Same for the initrd systemd.
    "rd.systemd.show_status=auto"
    # udevd is already err(3) by default; keep it explicit.
    "udev.log_level=3"
    "rd.udev.log_level=3"
    # No blinking VT cursor on the console.
    "vt.global_cursor_default=0"
  ];

  verboseParams = [
    "loglevel=7"
    "systemd.show_status=yes"
    "rd.systemd.show_status=yes"
    "udev.log_level=7"
    "rd.udev.log_level=7"
    "splash"
  ];
in

{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !cfg.enable || config.boot.plymouth.enable;
          message = "leenix.boot.visual.enable requires boot.plymouth.enable.";
        }
      ];
    }

    # Quiet normal boot. KERN_WARNING+ still reach the console; journal persists.
    (lib.mkIf (cfg.enable && !cfg.verbose) {
      boot.consoleLogLevel = 3;
      boot.kernelParams = quietParams;
    })

    # Verbose/recovery override: full console output, status shown.
    (lib.mkIf (cfg.enable && cfg.verbose) {
      boot.consoleLogLevel = 7;
      boot.kernelParams = verboseParams;
    })
  ];
}