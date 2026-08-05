{
  wayland.windowManager.hyprland.settings.windowrule = [
    # Ignore application maximize requests.
    "suppress_event maximize, match:class .*"

    # Work around invisible XWayland helper windows stealing focus.
    "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"

    # Firefox: nearly opaque, with no generic transparency applied.
    "tag +firefox-browser, match:class ([fF]irefox)"
    "opacity 1.0 0.985, match:tag firefox-browser"

    # Kitty and other common terminals.
    "tag +terminal, match:class (kitty|Alacritty|foot|com.mitchellh.ghostty)"
    "opacity 0.985 0.96, match:tag terminal"

    # Modal dialogs should float and open centered.
    "float on, match:modal 1"
    "center on, match:modal 1"

    # Picture-in-picture windows.
    "float on, match:title ^(Picture-in-Picture)$"
    "pin on, match:title ^(Picture-in-Picture)$"
    "keep_aspect_ratio on, match:title ^(Picture-in-Picture)$"

    # Prevent idle while fullscreen video or games are active.
    "idle_inhibit fullscreen, match:fullscreen 1"
  ];
}
