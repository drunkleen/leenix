{
  config,
  lib,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.power-profiles.enable {
    # Native NixOS power-profiles-daemon integration: system service,
    # D-Bus activation, powerprofilesctl client and platform backend
    # detection (ACPI platform_profile / intel_pstate) all come from the
    # pinned module. The module asserts TLP and auto-cpufreq are disabled.
    services.power-profiles-daemon.enable = true;
  };
}
