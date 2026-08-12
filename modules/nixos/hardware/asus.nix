{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.leenix.hardware.asus.enable {
    environment.systemPackages = with pkgs; [
      asusctl
    ];

    services.asusd.enable = true;

    # asusd also acts as a power manager: it switches the ACPI platform
    # profile (and the linked energy_performance_preference) whenever the
    # AC/battery state changes. power-profiles-daemon is the single
    # persistent power-profile backend, so disable asusd's automatic
    # profile/EPP management. asusd keeps handling fan curves, Aura and
    # explicit `asusctl profile set` calls.
    services.asusd.asusdConfig.text = ''
      (
          charge_control_end_threshold: 100,
          base_charge_control_end_threshold: 100,
          disable_nvidia_powerd_on_battery: true,
          ac_command: "",
          bat_command: "",
          platform_profile_linked_epp: false,
          platform_profile_on_battery: Quiet,
          change_platform_profile_on_battery: false,
          platform_profile_on_ac: Performance,
          change_platform_profile_on_ac: false,
          profile_quiet_epp: Power,
          profile_balanced_epp: BalancePower,
          profile_custom_epp: Performance,
          profile_performance_epp: Performance,
          ac_profile_tunings: {},
          dc_profile_tunings: {},
          armoury_settings: {},
      )
    '';
  };
}
