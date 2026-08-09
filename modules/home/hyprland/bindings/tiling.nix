{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "SUPER, W, Close window, killactive,"
      "CTRL ALT, DELETE, Close all windows, exec, leenix-hyprland-window-close-all"

      "SUPER, J, Toggle window split, layoutmsg, togglesplit"
      "SUPER, P, Pseudo window, pseudo,"
      "SUPER, T, Toggle window floating/tiling, togglefloating,"
      "SUPER, F, Full screen, fullscreen, 0"
      "SUPER CTRL, F, Tiled full screen, fullscreenstate, 0 2"
      "SUPER ALT, F, Full width, fullscreen, 1"
      "SUPER, O, Pop window out (float & pin), exec, leenix-hyprland-window-pop"
      "SUPER, L, Toggle workspace layout, exec, leenix-hyprland-workspace-layout-toggle"

      "SUPER, LEFT, Focus on left window, movefocus, l"
      "SUPER, RIGHT, Focus on right window, movefocus, r"
      "SUPER, UP, Focus on above window, movefocus, u"
      "SUPER, DOWN, Focus on below window, movefocus, d"

      "SUPER, code:10, Switch to workspace 1, workspace, 1"
      "SUPER, code:11, Switch to workspace 2, workspace, 2"
      "SUPER, code:12, Switch to workspace 3, workspace, 3"
      "SUPER, code:13, Switch to workspace 4, workspace, 4"
      "SUPER, code:14, Switch to workspace 5, workspace, 5"
      "SUPER, code:15, Switch to workspace 6, workspace, 6"
      "SUPER, code:16, Switch to workspace 7, workspace, 7"
      "SUPER, code:17, Switch to workspace 8, workspace, 8"
      "SUPER, code:18, Switch to workspace 9, workspace, 9"
      "SUPER, code:19, Switch to workspace 10, workspace, 10"

      "SUPER SHIFT, code:10, Move window to workspace 1, movetoworkspace, 1"
      "SUPER SHIFT, code:11, Move window to workspace 2, movetoworkspace, 2"
      "SUPER SHIFT, code:12, Move window to workspace 3, movetoworkspace, 3"
      "SUPER SHIFT, code:13, Move window to workspace 4, movetoworkspace, 4"
      "SUPER SHIFT, code:14, Move window to workspace 5, movetoworkspace, 5"
      "SUPER SHIFT, code:15, Move window to workspace 6, movetoworkspace, 6"
      "SUPER SHIFT, code:16, Move window to workspace 7, movetoworkspace, 7"
      "SUPER SHIFT, code:17, Move window to workspace 8, movetoworkspace, 8"
      "SUPER SHIFT, code:18, Move window to workspace 9, movetoworkspace, 9"
      "SUPER SHIFT, code:19, Move window to workspace 10, movetoworkspace, 10"

      "SUPER SHIFT ALT, code:10, Move window silently to workspace 1, movetoworkspacesilent, 1"
      "SUPER SHIFT ALT, code:11, Move window silently to workspace 2, movetoworkspacesilent, 2"
      "SUPER SHIFT ALT, code:12, Move window silently to workspace 3, movetoworkspacesilent, 3"
      "SUPER SHIFT ALT, code:13, Move window silently to workspace 4, movetoworkspacesilent, 4"
      "SUPER SHIFT ALT, code:14, Move window silently to workspace 5, movetoworkspacesilent, 5"
      "SUPER SHIFT ALT, code:15, Move window silently to workspace 6, movetoworkspacesilent, 6"
      "SUPER SHIFT ALT, code:16, Move window silently to workspace 7, movetoworkspacesilent, 7"
      "SUPER SHIFT ALT, code:17, Move window silently to workspace 8, movetoworkspacesilent, 8"
      "SUPER SHIFT ALT, code:18, Move window silently to workspace 9, movetoworkspacesilent, 9"
      "SUPER SHIFT ALT, code:19, Move window silently to workspace 10, movetoworkspacesilent, 10"

      "SUPER, S, Toggle scratchpad, togglespecialworkspace, scratchpad"
      "SUPER ALT, S, Move window to scratchpad, movetoworkspacesilent, special:scratchpad"

      "SUPER, TAB, Next workspace, workspace, e+1"
      "SUPER SHIFT, TAB, Previous workspace, workspace, e-1"
      "SUPER CTRL, TAB, Former workspace, workspace, previous"

      "SUPER SHIFT ALT, LEFT, Move workspace to left monitor, movecurrentworkspacetomonitor, l"
      "SUPER SHIFT ALT, RIGHT, Move workspace to right monitor, movecurrentworkspacetomonitor, r"
      "SUPER SHIFT ALT, UP, Move workspace to up monitor, movecurrentworkspacetomonitor, u"
      "SUPER SHIFT ALT, DOWN, Move workspace to down monitor, movecurrentworkspacetomonitor, d"

      "SUPER SHIFT, LEFT, Swap window to the left, swapwindow, l"
      "SUPER SHIFT, RIGHT, Swap window to the right, swapwindow, r"
      "SUPER SHIFT, UP, Swap window up, swapwindow, u"
      "SUPER SHIFT, DOWN, Swap window down, swapwindow, d"

      "ALT, TAB, Focus on next window, cyclenext"
      "ALT SHIFT, TAB, Focus on previous window, cyclenext, prev"
      "ALT, TAB, Reveal active window on top, bringactivetotop"
      "ALT SHIFT, TAB, Reveal active window on top, bringactivetotop"

      "CTRL ALT, TAB, Focus on next monitor, focusmonitor, +1"
      "CTRL ALT SHIFT, TAB, Focus on previous monitor, focusmonitor, -1"

      "SUPER, code:20, Expand window left, resizeactive, -100 0"
      "SUPER, code:21, Shrink window left, resizeactive, 100 0"
      "SUPER SHIFT, code:20, Shrink window up, resizeactive, 0 -100"
      "SUPER SHIFT, code:21, Expand window down, resizeactive, 0 100"

      "SUPER, mouse_down, Scroll active workspace forward, workspace, e+1"
      "SUPER, mouse_up, Scroll active workspace backward, workspace, e-1"

      "SUPER, G, Toggle window grouping, togglegroup"
      "SUPER ALT, G, Move active window out of group, moveoutofgroup"

      "SUPER ALT, LEFT, Move window to group on left, moveintogroup, l"
      "SUPER ALT, RIGHT, Move window to group on right, moveintogroup, r"
      "SUPER ALT, UP, Move window to group on top, moveintogroup, u"
      "SUPER ALT, DOWN, Move window to group on bottom, moveintogroup, d"

      "SUPER ALT, TAB, Next window in group, changegroupactive, f"
      "SUPER ALT SHIFT, TAB, Previous window in group, changegroupactive, b"

      "SUPER CTRL, LEFT, Move grouped window focus left, changegroupactive, b"
      "SUPER CTRL, RIGHT, Move grouped window focus right, changegroupactive, f"

      "SUPER ALT, mouse_down, Next window in group, changegroupactive, f"
      "SUPER ALT, mouse_up, Previous window in group, changegroupactive, b"

      "SUPER ALT, code:10, Switch to group window 1, changegroupactive, 1"
      "SUPER ALT, code:11, Switch to group window 2, changegroupactive, 2"
      "SUPER ALT, code:12, Switch to group window 3, changegroupactive, 3"
      "SUPER ALT, code:13, Switch to group window 4, changegroupactive, 4"
      "SUPER ALT, code:14, Switch to group window 5, changegroupactive, 5"
    ];

    bindmd = [
      "SUPER, mouse:272, Move window, movewindow"
      "SUPER, mouse:273, Resize window, resizewindow"
    ];
  };
}
