{
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";

    bind = [
      # Applications
      "$mod, RETURN, exec, uwsm app -- kitty"
      "$mod SHIFT, RETURN, exec, uwsm app -- firefox"
      "$mod, B, exec, uwsm app -- firefox"
      "$mod SHIFT, F, exec, uwsm app -- kitty -e yazi"
      "$mod, SPACE, exec, walker"

      # Window management
      "$mod, Q, killactive"
      "$mod SHIFT, E, exit"
      "$mod, F, fullscreen"
      "$mod, V, togglefloating"

      # Focus
      "$mod, H, movefocus, l"
      "$mod, J, movefocus, d"
      "$mod, K, movefocus, u"
      "$mod, L, movefocus, r"

      # Workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"

      # Move windows to workspaces
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
      "$mod SHIFT, 0, movetoworkspace, 10"

      # Hardware panels (temporary fallback tools until custom panels land)
      "$mod CTRL, A, exec, pwvucontrol"
      "$mod CTRL, B, exec, blueman-manager"
      "$mod CTRL, W, exec, nm-connection-editor"
      "$mod CTRL, D, exec, hyprctl monitors"

      # Lock the session
      "$mod CTRL, L, exec, loginctl lock-session"
    ];

    # Repeat while the key is held
    bindel = [
      # Output volume
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"

      # Precise volume
      "ALT, XF86AudioRaiseVolume, exec, swayosd-client --output-volume +1"
      "ALT, XF86AudioLowerVolume, exec, swayosd-client --output-volume -1"

      # Display brightness
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"

      # Precise brightness
      "ALT, XF86MonBrightnessUp, exec, swayosd-client --brightness +1"
      "ALT, XF86MonBrightnessDown, exec, swayosd-client --brightness -1"
    ];

    # Works while the session is locked
    bindl = [
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"

      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"

      ", XF86TouchpadToggle, exec, leenix-toggle-touchpad"
    ];
  };
}
