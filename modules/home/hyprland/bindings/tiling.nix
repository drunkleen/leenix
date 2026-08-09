{ lib, ... }:

let
  binds = [
    {
      keys = "SUPER + W";
      description = "Close window";
      action = ''hl.dsp.window.close({})'';
    }
    {
      keys = "CTRL + ALT + DELETE";
      description = "Close all windows";
      action = ''hl.dsp.exec_cmd("leenix-hyprland-window-close-all")'';
    }

    {
      keys = "SUPER + J";
      description = "Toggle window split";
      action = ''hl.dsp.layout("togglesplit")'';
    }
    {
      keys = "SUPER + P";
      description = "Pseudo window";
      action = ''hl.dsp.window.pseudo({})'';
    }
    {
      keys = "SUPER + T";
      description = "Toggle window floating/tiling";
      action = ''hl.dsp.window.float({})'';
    }
    {
      keys = "SUPER + F";
      description = "Full screen";
      action = ''hl.dsp.window.fullscreen({ mode = "fullscreen" })'';
    }
    {
      keys = "SUPER + CTRL + F";
      description = "Tiled full screen";
      action = ''hl.dsp.window.fullscreen_state({ internal = 0, client = 2 })'';
    }
    {
      keys = "SUPER + ALT + F";
      description = "Full width";
      action = ''hl.dsp.window.fullscreen({ mode = "maximized" })'';
    }
    {
      keys = "SUPER + O";
      description = "Pop window out (float & pin)";
      action = ''hl.dsp.exec_cmd("leenix-hyprland-window-pop")'';
    }
    {
      keys = "SUPER + L";
      description = "Toggle workspace layout";
      action = ''hl.dsp.exec_cmd("leenix-hyprland-workspace-layout-toggle")'';
    }

    # Focus windows
    {
      keys = "SUPER + LEFT";
      description = "Focus on left window";
      action = ''hl.dsp.focus({ direction = "l" })'';
    }
    {
      keys = "SUPER + RIGHT";
      description = "Focus on right window";
      action = ''hl.dsp.focus({ direction = "r" })'';
    }
    {
      keys = "SUPER + UP";
      description = "Focus on above window";
      action = ''hl.dsp.focus({ direction = "u" })'';
    }
    {
      keys = "SUPER + DOWN";
      description = "Focus on below window";
      action = ''hl.dsp.focus({ direction = "d" })'';
    }

    # Workspaces
    {
      keys = "SUPER + code:10";
      description = "Switch to workspace 1";
      action = ''hl.dsp.focus({ workspace = "1" })'';
    }
    {
      keys = "SUPER + code:11";
      description = "Switch to workspace 2";
      action = ''hl.dsp.focus({ workspace = "2" })'';
    }
    {
      keys = "SUPER + code:12";
      description = "Switch to workspace 3";
      action = ''hl.dsp.focus({ workspace = "3" })'';
    }
    {
      keys = "SUPER + code:13";
      description = "Switch to workspace 4";
      action = ''hl.dsp.focus({ workspace = "4" })'';
    }
    {
      keys = "SUPER + code:14";
      description = "Switch to workspace 5";
      action = ''hl.dsp.focus({ workspace = "5" })'';
    }
    {
      keys = "SUPER + code:15";
      description = "Switch to workspace 6";
      action = ''hl.dsp.focus({ workspace = "6" })'';
    }
    {
      keys = "SUPER + code:16";
      description = "Switch to workspace 7";
      action = ''hl.dsp.focus({ workspace = "7" })'';
    }
    {
      keys = "SUPER + code:17";
      description = "Switch to workspace 8";
      action = ''hl.dsp.focus({ workspace = "8" })'';
    }
    {
      keys = "SUPER + code:18";
      description = "Switch to workspace 9";
      action = ''hl.dsp.focus({ workspace = "9" })'';
    }
    {
      keys = "SUPER + code:19";
      description = "Switch to workspace 10";
      action = ''hl.dsp.focus({ workspace = "10" })'';
    }

    # Move window to workspace
    {
      keys = "SUPER + SHIFT + code:10";
      description = "Move window to workspace 1";
      action = ''hl.dsp.window.move({ workspace = "1", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:11";
      description = "Move window to workspace 2";
      action = ''hl.dsp.window.move({ workspace = "2", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:12";
      description = "Move window to workspace 3";
      action = ''hl.dsp.window.move({ workspace = "3", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:13";
      description = "Move window to workspace 4";
      action = ''hl.dsp.window.move({ workspace = "4", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:14";
      description = "Move window to workspace 5";
      action = ''hl.dsp.window.move({ workspace = "5", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:15";
      description = "Move window to workspace 6";
      action = ''hl.dsp.window.move({ workspace = "6", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:16";
      description = "Move window to workspace 7";
      action = ''hl.dsp.window.move({ workspace = "7", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:17";
      description = "Move window to workspace 8";
      action = ''hl.dsp.window.move({ workspace = "8", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:18";
      description = "Move window to workspace 9";
      action = ''hl.dsp.window.move({ workspace = "9", follow = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:19";
      description = "Move window to workspace 10";
      action = ''hl.dsp.window.move({ workspace = "10", follow = true })'';
    }

    # Move silently
    {
      keys = "SUPER + SHIFT + ALT + code:10";
      description = "Move window silently to workspace 1";
      action = ''hl.dsp.window.move({ workspace = "1", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:11";
      description = "Move window silently to workspace 2";
      action = ''hl.dsp.window.move({ workspace = "2", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:12";
      description = "Move window silently to workspace 3";
      action = ''hl.dsp.window.move({ workspace = "3", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:13";
      description = "Move window silently to workspace 4";
      action = ''hl.dsp.window.move({ workspace = "4", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:14";
      description = "Move window silently to workspace 5";
      action = ''hl.dsp.window.move({ workspace = "5", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:15";
      description = "Move window silently to workspace 6";
      action = ''hl.dsp.window.move({ workspace = "6", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:16";
      description = "Move window silently to workspace 7";
      action = ''hl.dsp.window.move({ workspace = "7", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:17";
      description = "Move window silently to workspace 8";
      action = ''hl.dsp.window.move({ workspace = "8", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:18";
      description = "Move window silently to workspace 9";
      action = ''hl.dsp.window.move({ workspace = "9", follow = false })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + code:19";
      description = "Move window silently to workspace 10";
      action = ''hl.dsp.window.move({ workspace = "10", follow = false })'';
    }

    # Scratchpad
    {
      keys = "SUPER + S";
      description = "Toggle scratchpad";
      action = ''hl.dsp.workspace.toggle_special("scratchpad")'';
    }
    {
      keys = "SUPER + ALT + S";
      description = "Move window to scratchpad";
      action = ''hl.dsp.window.move({ workspace = "special:scratchpad", follow = false })'';
    }

    # Workspace navigation
    {
      keys = "SUPER + TAB";
      description = "Next workspace";
      action = ''hl.dsp.focus({ workspace = "e+1" })'';
    }
    {
      keys = "SUPER + SHIFT + TAB";
      description = "Previous workspace";
      action = ''hl.dsp.focus({ workspace = "e-1" })'';
    }
    {
      keys = "SUPER + CTRL + TAB";
      description = "Former workspace";
      action = ''hl.dsp.focus({ workspace = "previous" })'';
    }

    # Move workspace between monitors
    {
      keys = "SUPER + SHIFT + ALT + LEFT";
      description = "Move workspace to left monitor";
      action = ''hl.dsp.workspace.move({ monitor = "l" })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + RIGHT";
      description = "Move workspace to right monitor";
      action = ''hl.dsp.workspace.move({ monitor = "r" })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + UP";
      description = "Move workspace to up monitor";
      action = ''hl.dsp.workspace.move({ monitor = "u" })'';
    }
    {
      keys = "SUPER + SHIFT + ALT + DOWN";
      description = "Move workspace to down monitor";
      action = ''hl.dsp.workspace.move({ monitor = "d" })'';
    }

    # Swap windows
    {
      keys = "SUPER + SHIFT + LEFT";
      description = "Swap window to the left";
      action = ''hl.dsp.window.swap({ direction = "l" })'';
    }
    {
      keys = "SUPER + SHIFT + RIGHT";
      description = "Swap window to the right";
      action = ''hl.dsp.window.swap({ direction = "r" })'';
    }
    {
      keys = "SUPER + SHIFT + UP";
      description = "Swap window up";
      action = ''hl.dsp.window.swap({ direction = "u" })'';
    }
    {
      keys = "SUPER + SHIFT + DOWN";
      description = "Swap window down";
      action = ''hl.dsp.window.swap({ direction = "d" })'';
    }

    # Alt-tab
    {
      keys = "ALT + TAB";
      description = "Focus on next window";
      action = ''hl.dsp.window.cycle_next({ next = true })'';
    }
    {
      keys = "ALT + SHIFT + TAB";
      description = "Focus on previous window";
      action = ''hl.dsp.window.cycle_next({ next = false })'';
    }
    {
      keys = "ALT + TAB";
      description = "Reveal active window on top";
      action = ''hl.dsp.window.alter_zorder({ mode = "top" })'';
    }
    {
      keys = "ALT + SHIFT + TAB";
      description = "Reveal active window on top";
      action = ''hl.dsp.window.alter_zorder({ mode = "top" })'';
    }

    # Monitor focus
    {
      keys = "CTRL + ALT + TAB";
      description = "Focus on next monitor";
      action = ''hl.dsp.focus({ monitor = "+1" })'';
    }
    {
      keys = "CTRL + ALT + SHIFT + TAB";
      description = "Focus on previous monitor";
      action = ''hl.dsp.focus({ monitor = "-1" })'';
    }

    # Resize
    {
      keys = "SUPER + code:20";
      description = "Expand window left";
      action = ''hl.dsp.window.resize({ x = -100, y = 0, relative = true })'';
    }
    {
      keys = "SUPER + code:21";
      description = "Shrink window left";
      action = ''hl.dsp.window.resize({ x = 100, y = 0, relative = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:20";
      description = "Shrink window up";
      action = ''hl.dsp.window.resize({ x = 0, y = -100, relative = true })'';
    }
    {
      keys = "SUPER + SHIFT + code:21";
      description = "Expand window down";
      action = ''hl.dsp.window.resize({ x = 0, y = 100, relative = true })'';
    }

    # Mouse wheel workspace
    {
      keys = "SUPER + mouse_down";
      description = "Scroll active workspace forward";
      action = ''hl.dsp.focus({ workspace = "e+1" })'';
    }
    {
      keys = "SUPER + mouse_up";
      description = "Scroll active workspace backward";
      action = ''hl.dsp.focus({ workspace = "e-1" })'';
    }

    # Groups
    {
      keys = "SUPER + G";
      description = "Toggle window grouping";
      action = ''hl.dsp.group.toggle({})'';
    }
    {
      keys = "SUPER + ALT + G";
      description = "Move active window out of group";
      action = ''hl.dsp.window.move({ out_of_group = true })'';
    }

    {
      keys = "SUPER + ALT + LEFT";
      description = "Move window to group on left";
      action = ''hl.dsp.window.move({ into_group = "l" })'';
    }
    {
      keys = "SUPER + ALT + RIGHT";
      description = "Move window to group on right";
      action = ''hl.dsp.window.move({ into_group = "r" })'';
    }
    {
      keys = "SUPER + ALT + UP";
      description = "Move window to group on top";
      action = ''hl.dsp.window.move({ into_group = "u" })'';
    }
    {
      keys = "SUPER + ALT + DOWN";
      description = "Move window to group on bottom";
      action = ''hl.dsp.window.move({ into_group = "d" })'';
    }

    {
      keys = "SUPER + ALT + TAB";
      description = "Next window in group";
      action = ''hl.dsp.group.next({})'';
    }
    {
      keys = "SUPER + ALT + SHIFT + TAB";
      description = "Previous window in group";
      action = ''hl.dsp.group.prev({})'';
    }

    {
      keys = "SUPER + CTRL + LEFT";
      description = "Move grouped window focus left";
      action = ''hl.dsp.group.prev({})'';
    }
    {
      keys = "SUPER + CTRL + RIGHT";
      description = "Move grouped window focus right";
      action = ''hl.dsp.group.next({})'';
    }

    {
      keys = "SUPER + ALT + mouse_down";
      description = "Next window in group";
      action = ''hl.dsp.group.next({})'';
    }
    {
      keys = "SUPER + ALT + mouse_up";
      description = "Previous window in group";
      action = ''hl.dsp.group.prev({})'';
    }

    {
      keys = "SUPER + ALT + code:10";
      description = "Switch to group window 1";
      action = ''hl.dsp.group.active({ index = 1 })'';
    }
    {
      keys = "SUPER + ALT + code:11";
      description = "Switch to group window 2";
      action = ''hl.dsp.group.active({ index = 2 })'';
    }
    {
      keys = "SUPER + ALT + code:12";
      description = "Switch to group window 3";
      action = ''hl.dsp.group.active({ index = 3 })'';
    }
    {
      keys = "SUPER + ALT + code:13";
      description = "Switch to group window 4";
      action = ''hl.dsp.group.active({ index = 4 })'';
    }
    {
      keys = "SUPER + ALT + code:14";
      description = "Switch to group window 5";
      action = ''hl.dsp.group.active({ index = 5 })'';
    }
  ];

  mouseBinds = [
    {
      keys = "SUPER + mouse:272";
      description = "Move window";
      action = ''hl.dsp.window.drag()'';
    }
    {
      keys = "SUPER + mouse:273";
      description = "Resize window";
      action = ''hl.dsp.window.resize()'';
    }
  ];

  bindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          ${bind.action},
          { description = ${builtins.toJSON bind.description} }
        )
      '')
      binds;

  mouseBindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          ${bind.action},
          {
            mouse = true,
            description = ${builtins.toJSON bind.description}
          }
        )
      '')
      mouseBinds;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${bindLines}

    ${mouseBindLines}
  '';
}
