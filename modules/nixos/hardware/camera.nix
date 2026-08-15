{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.leenix.hardware.camera;

  # udev helper: given the DEVPATH of a USB video-class interface, walk up to
  # the owning USB device and deauthorize it. (bInterfaceClass lives on the
  # interface; `authorized` lives on the parent device, so a plain
  # `ATTR{authorized}="0"` against the interface is a silent no-op — the RUN
  # program resolves the real device.)
  cameraPrivacy = pkgs.writeShellScript "leenix-camera-privacy" ''
    set -u
    p="/sys''${1:-}"
    i=0
    while [ -n "$p" ] && [ "$i" -lt 10 ]; do
      if [ -w "$p/authorized" ]; then
        echo 0 > "$p/authorized" 2>/dev/null
        exit 0
      fi
      p=''${p%/*}
      i=$((i + 1))
    done
    exit 0
  '';
in
{
  # LEENIX camera privacy policy.
  #
  # MODEL
  #   Declarative default (this module): privacy = ON. A udev rule deauthorizes
  #   the USB device behind every USB video-class interface at device-ADD time,
  #   so cameras are genuinely unavailable at boot and after every (re)plug.
  #
  #   The rule is restricted to ACTION=="add". Writing `authorized=1` via
  #   `leenix-camera enable` emits a `change` event (not `add`), so the runtime
  #   grant is NOT instantly re-deauthorized by this rule — it sticks for the
  #   current session / device attachment. A physical replug or reboot re-emits
  #   `add` and the camera is deauthorized again (privacy restored).
  #
  #   Runtime override (leenix-camera enable/disable, pkexec): writes the
  #   per-device sysfs `authorized` attribute for the CURRENT session /
  #   device attachment. This is intentionally SESSION-SCOPED:
  #     - it does not touch udev rules,
  #     - the next replug or reboot re-runs this udev rule and the camera is
  #       deauthorized again (privacy restored),
  #     - `leenix-camera status` reports BOTH desired (state file) and
  #       effective (sysfs authorized) so a state file never claims a camera is
  #       enabled while the effective udev state is disabled.
  #
  #   Privacy is never weakened to make testing easier: the declarative default
  #   stays enforced by udev on every attachment.
  #
  # SCOPE / IMPACT
  #   This rule matches ANY USB interface exposing a Video class
  #   (bInterfaceClass 0x0E): integrated UVC cameras, USB webcams AND generic
  #   USB UVC capture cards (e.g. Magewell/Hauppauge-style devices) are all
  #   deauthorized. PCIe/Thunderbolt capture devices that do not enumerate as
  #   USB video are unaffected. Hosts that need a UVC capture card must either
  #   set variables.hardware.camera.privacy = false (declarative) or re-grant
  #   the device per attachment with `leenix-camera enable`.
  config = lib.mkIf cfg.privacy {
    services.udev.extraRules = ''
      # LEENIX camera privacy: deauthorize the USB device of video-class interfaces.
      ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="0e", RUN+="${cameraPrivacy} $env{DEVPATH}"
    '';
  };
}
