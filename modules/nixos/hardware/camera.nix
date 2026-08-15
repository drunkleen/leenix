{
  config,
  lib,
  ...
}:

let
  cfg = config.leenix.hardware.camera;
in
{
  # LEENIX camera privacy policy.
  #
  # MODEL (interface-level, narrow primitive)
  #   Declarative default (this module): privacy = ON. A udev rule deauthorizes
  #   ONLY the USB VIDEO interfaces (bInterfaceClass 0x0E) of a camera at
  #   device-ADD time. A deauthorized USB interface never binds a driver, so no
  #   /dev/video* appears at boot or after a (re)plug. Non-video interfaces of a
  #   composite camera (microphone/audio, IR, HID/control) are untouched, and
  #   the parent USB device is never deauthorized.
  #
  #   USB interfaces expose their own `authorized` sysfs attribute, so the rule
  #   writes it directly — no RUN script, no parent walk, no timing race.
  #
  #   Runtime override (leenix-camera enable/disable via the privileged helper
  #   leenix-camera-privileged, pkexec): writes `authorized` on the SAME video
  #   interfaces for the CURRENT session / device attachment. Writing it emits a
  #   `change` event (not `add`), so this rule does not re-fire; the grant sticks
  #   until a physical replug or reboot re-emits `add` and privacy is restored.
  #
  # SCOPE / IMPACT
  #   Matches ANY USB interface exposing a Video class (bInterfaceClass 0x0E):
  #   integrated UVC cameras, USB webcams and generic USB UVC capture cards are
  #   all deauthorized. PCIe/Thunderbolt video devices that do not enumerate as
  #   USB video are unaffected. Hosts that need a UVC capture card must either
  #   set variables.hardware.camera.privacy = false (declarative) or re-grant
  #   the device per attachment with `leenix-camera enable`.
  config = lib.mkIf cfg.privacy {
    services.udev.extraRules = ''
      # LEENIX camera privacy: deauthorize USB video interfaces at add time.
      ACTION=="add", SUBSYSTEM=="usb", ATTR{bInterfaceClass}=="0e", ATTR{authorized}="0"
    '';
  };
}
