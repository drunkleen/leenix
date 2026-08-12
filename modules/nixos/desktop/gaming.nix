{
  config,
  lib,
  pkgs,
  ...
}:

# LEENIX gaming stack (composition). Gated by leenix.profiles.gaming.enable.
# NVIDIA PRIME offload / power management live in the hardware/nvidia module;
# this module owns the gaming software layer only.
{
  config = lib.mkIf config.leenix.profiles.gaming.enable {
    programs.steam.enable = true;
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
      # scoped CAP_SYS_NICE on the gamescope binary so it can renice itself
      # for lower-latency scheduling; affects only gamescope, not the system.
      capSysNice = true;
    };

    # GameMode changes the CPU governor through cpugovctl via pkexec, gated by
    # the polkit action com.feralinteractive.GameMode.governor-helper (default:
    # deny for everyone). Authorize members of the `gamemode` group for this
    # one action so the governor can be switched while GameMode is active.
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (action.id == "com.feralinteractive.GameMode.governor-helper" &&
            subject.isInGroup("gamemode")) {
          return polkit.Result.YES;
        }
      });
    '';

    # 32-bit graphics for Steam/Proton (Steam also enables this itself).
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
      vulkan-tools # vulkaninfo
      mesa-demos # glxinfo, eglinfo
      mangohud
      protonup-qt # optional GE-Proton installer (does not replace Proton Experimental)
      protontricks
      # `leenix-game-run`: prime-run + gamemoderun, with optional --mangohud /
      # --gamescope flags.
      (pkgs.writeShellApplication {
        name = "leenix-game-run";

        text = ''
          #!/bin/bash

          # leenix:summary=Run a command with PRIME NVIDIA offload + GameMode.

          # leenix:args=[--mangohud] [--gamescope] <command>...

          mangohud_flag=0
          gamescope_flag=0
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --mangohud) mangohud_flag=1; shift ;;
              --gamescope) gamescope_flag=1; shift ;;
              *) break ;;
            esac
          done

          cmd="prime-run gamemoderun"
          if (( gamescope_flag )); then
            cmd="$cmd gamescope --"
          fi
          if (( mangohud_flag )); then
            cmd="$cmd mangohud"
          fi

          exec $cmd "$@"
        '';
      })
    ];
  };
}
