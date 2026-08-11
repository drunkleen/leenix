{ lib, ... }:

let
  repeatingLockedBinds = [
    {
      keys = "XF86AudioRaiseVolume";
      description = "Volume up";
      command = "leenix-swayosd-client --output-volume raise";
    }
    {
      keys = "XF86AudioLowerVolume";
      description = "Volume down";
      command = "leenix-swayosd-client --output-volume lower";
    }
    {
      keys = "XF86AudioMute";
      description = "Mute";
      command = "leenix-swayosd-client --output-volume mute-toggle";
    }
    {
      keys = "XF86AudioMicMute";
      description = "Mute microphone";
      command = "leenix-audio-input-mute";
    }
    {
      keys = "XF86MonBrightnessUp";
      description = "Brightness up";
      command = "leenix-brightness-display +5%";
    }
    {
      keys = "XF86MonBrightnessDown";
      description = "Brightness down";
      command = "leenix-brightness-display 5%-";
    }
    {
      keys = "SHIFT + XF86MonBrightnessUp";
      description = "Brightness maximum";
      command = "leenix-brightness-display 100%";
    }
    {
      keys = "SHIFT + XF86MonBrightnessDown";
      description = "Brightness minimum";
      command = "leenix-brightness-display 1%";
    }
    {
      keys = "XF86KbdBrightnessUp";
      description = "Keyboard brightness up";
      command = "leenix-brightness-keyboard up";
    }
    {
      keys = "XF86KbdBrightnessDown";
      description = "Keyboard brightness down";
      command = "leenix-brightness-keyboard down";
    }
    {
      keys = "ALT + XF86AudioRaiseVolume";
      description = "Volume up precise";
      command = "leenix-swayosd-client --output-volume +1";
    }
    {
      keys = "ALT + XF86AudioLowerVolume";
      description = "Volume down precise";
      command = "leenix-swayosd-client --output-volume -1";
    }
    {
      keys = "ALT + XF86MonBrightnessUp";
      description = "Brightness up precise";
      command = "leenix-brightness-display +1%";
    }
    {
      keys = "ALT + XF86MonBrightnessDown";
      description = "Brightness down precise";
      command = "leenix-brightness-display 1%-";
    }
  ];

  lockedBinds = [
    {
      keys = "XF86KbdLightOnOff";
      description = "Keyboard backlight cycle";
      command = "leenix-brightness-keyboard cycle";
    }
    {
      keys = "XF86TouchpadToggle";
      description = "Toggle touchpad";
      command = "leenix-toggle-touchpad";
    }
    {
      keys = "XF86TouchpadOn";
      description = "Enable touchpad";
      command = "leenix-toggle-touchpad on";
    }
    {
      keys = "XF86TouchpadOff";
      description = "Disable touchpad";
      command = "leenix-toggle-touchpad off";
    }
    {
      keys = "XF86AudioNext";
      description = "Next track";
      command = "leenix-swayosd-client --playerctl next";
    }
    {
      keys = "XF86AudioPause";
      description = "Pause";
      command = "leenix-swayosd-client --playerctl play-pause";
    }
    {
      keys = "XF86AudioPlay";
      description = "Play";
      command = "leenix-swayosd-client --playerctl play-pause";
    }
    {
      keys = "XF86AudioPrev";
      description = "Previous track";
      command = "leenix-swayosd-client --playerctl previous";
    }
    {
      keys = "SUPER + XF86AudioMute";
      description = "Switch audio output";
      command = "leenix-audio-output-switch";
    }
  ];

  repeatingLockedLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            repeating = true,
            locked = true,
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      repeatingLockedBinds;

  lockedLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          {
            locked = true,
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      lockedBinds;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${repeatingLockedLines}

    ${lockedLines}
  '';
}
