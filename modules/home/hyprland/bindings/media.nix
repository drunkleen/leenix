{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindeld = [
      ",XF86AudioRaiseVolume, Volume up, exec, leenix-swayosd-client --output-volume raise"
      ",XF86AudioLowerVolume, Volume down, exec, leenix-swayosd-client --output-volume lower"
      ",XF86AudioMute, Mute, exec, leenix-swayosd-client --output-volume mute-toggle"
      ",XF86AudioMicMute, Mute microphone, exec, leenix-audio-input-mute"
      ",XF86MonBrightnessUp, Brightness up, exec, leenix-brightness-display +5%"
      ",XF86MonBrightnessDown, Brightness down, exec, leenix-brightness-display 5%-"
      "SHIFT, XF86MonBrightnessUp, Brightness maximum, exec, leenix-brightness-display 100%"
      "SHIFT, XF86MonBrightnessDown, Brightness minimum, exec, leenix-brightness-display 1%"
      ",XF86KbdBrightnessUp, Keyboard brightness up, exec, leenix-brightness-keyboard up"
      ",XF86KbdBrightnessDown, Keyboard brightness down, exec, leenix-brightness-keyboard down"
    ];

    bindld = [
      ",XF86KbdLightOnOff, Keyboard backlight cycle, exec, leenix-brightness-keyboard cycle"
      ",XF86TouchpadToggle, Toggle touchpad, exec, leenix-toggle-touchpad"
      ",XF86TouchpadOn, Enable touchpad, exec, leenix-toggle-touchpad on"
      ",XF86TouchpadOff, Disable touchpad, exec, leenix-toggle-touchpad off"
      ",XF86AudioNext, Next track, exec, leenix-swayosd-client --playerctl next"
      ",XF86AudioPause, Pause, exec, leenix-swayosd-client --playerctl play-pause"
      ",XF86AudioPlay, Play, exec, leenix-swayosd-client --playerctl play-pause"
      ",XF86AudioPrev, Previous track, exec, leenix-swayosd-client --playerctl previous"
      "SUPER, XF86AudioMute, Switch audio output, exec, leenix-audio-output-switch"
    ];
  };
}
