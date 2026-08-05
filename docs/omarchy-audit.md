# Omarchy Master Audit

Reference:

- https://github.com/basecamp/omarchy/tree/master

## Rules

- Omarchy master is the UX reference.
- Implementation must remain Nix-native and modular.
- Firefox replaces Omarchy's default browser.
- Existing minimal Hyprland and Waybar remain until their replacements pass testing.
- No component is finalized before its upstream Omarchy config is audited.

## Hyprland configuration model

Omarchy separates configuration into:

### Defaults

- autostart
- media bindings
- clipboard bindings
- tiling bindings
- utility bindings
- environment variables
- look and feel
- input
- window rules
- app-specific rules

### Theme

- Hyprland colors are sourced from the active Omarchy theme.

### User overrides

- monitors
- input
- bindings
- look and feel
- autostart

### Runtime toggles

- Dynamic toggle files are sourced separately.

## Mapping to our repository

| Omarchy | NixOS repository |
|---|---|
| default/hypr/autostart.conf | modules/home/hyprland/startup.nix |
| default/hypr/bindings/media.conf | modules/home/hyprland/binds/media.nix |
| default/hypr/bindings/clipboard.conf | modules/home/hyprland/binds/clipboard.nix |
| default/hypr/bindings/tiling-v2.conf | modules/home/hyprland/binds/tiling.nix |
| default/hypr/bindings/utilities.conf | modules/home/hyprland/binds/utilities.nix |
| default/hypr/envs.conf | modules/home/hyprland/environment.nix |
| default/hypr/looknfeel.conf | decoration.nix + animations.nix |
| default/hypr/input.conf | modules/home/hyprland/input.nix |
| default/hypr/windows.conf | modules/home/hyprland/rules.nix |
| config/hypr/monitors.conf | modules/home/hyprland/monitors.nix |
| config/walker/config.toml | modules/home/walker/ |
| config/waybar/ | modules/home/waybar/ |
| active theme | modules/home/themes/omarchy/ |

## Confirmed keybindings

### Menus

- Super + Space: Walker application launcher
- Super + Alt + Space: Omarchy menu
- Super + Escape: system/power menu
- Super + K: keybinding menu
- Super + Ctrl + E: emoji picker

### Clipboard

- Super + C: universal copy
- Super + V: universal paste
- Super + X: universal cut
- Super + Ctrl + V: clipboard history

### Notifications

- Super + Comma: dismiss last
- Super + Shift + Comma: dismiss all
- Super + Alt + Comma: invoke action
- Super + Shift + Alt + Comma: restore last
- Super + Ctrl + Comma: silence toggle

### Capture

- Print: screenshot
- Alt + Print: screen recording
- Super + Print: color picker
- Super + Ctrl + Print: OCR capture

### Control panels

- Super + Ctrl + A: audio controls
- Super + Ctrl + B: Bluetooth controls
- Super + Ctrl + W: Wi-Fi controls
- Super + Ctrl + T: btop

### Session

- Super + Ctrl + L: lock
- Super + Escape: system menu

### Media

- Hardware volume keys use SwayOSD
- Hardware brightness keys use SwayOSD/helper scripts
- Hardware keyboard-backlight keys are supported
- Media playback keys use playerctl

## Required Nix-native replacements

Omarchy helper commands cannot be copied directly. We need equivalents for:

- omarchy-launch-walker
- omarchy-menu
- omarchy-menu-keybindings
- omarchy-toggle-waybar
- omarchy-toggle-notification-silencing
- omarchy-system-lock
- omarchy-capture-screenshot
- omarchy-launch-audio
- omarchy-launch-bluetooth
- omarchy-launch-wifi
- omarchy-swayosd-client
- brightness helpers
- monitor toggles
- theme switching

## Decisions

- Walker replaces Rofi.
- Mako replaces the abandoned SwayNC experiment.
- SwayOSD handles volume and brightness feedback.
- Firefox replaces Omarchy's browser command.
- Current Waybar remains temporarily and will be atomically replaced.
- Current minimal bindings remain until the full binding map is ready.

## Next audit targets

1. tiling-v2.conf
2. looknfeel.conf
3. input.conf
4. envs.conf
5. autostart.conf
6. windows.conf
7. Walker configuration
8. Waybar configuration
9. Mako configuration
10. Hyprlock and Hypridle



## Tiling and window management audit

Source:

- `default/hypr/bindings/tiling-v2.conf`

### Close and window state

- Super + W: close active window
- Ctrl + Alt + Delete: close all windows
- Super + J: toggle split
- Super + P: pseudo window
- Super + T: toggle floating/tiling
- Super + F: fullscreen
- Super + Ctrl + F: tiled fullscreen
- Super + Alt + F: full-width window
- Super + O: float and pin active window
- Super + L: switch workspace layout

### Focus and workspace navigation

- Super + Arrow: move focus
- Super + 1–0: workspaces 1–10
- Super + Shift + 1–0: move and follow window
- Super + Shift + Alt + 1–0: move window silently
- Super + Tab: next workspace
- Super + Shift + Tab: previous workspace
- Super + Ctrl + Tab: former workspace

### Scratchpad

- Super + S: toggle scratchpad
- Super + Alt + S: move active window to scratchpad

### Window movement and resizing

- Super + Shift + Arrow: swap windows
- Super + minus/equal: horizontal resize
- Super + Shift + minus/equal: vertical resize
- Super + left mouse drag: move
- Super + right mouse drag: resize

### Multi-monitor behavior

- Super + Shift + Alt + Arrow: move current workspace between monitors
- Ctrl + Alt + Tab: next monitor
- Ctrl + Alt + Shift + Tab: previous monitor
- Super + slash: cycle monitor scaling

### Window groups

- Super + G: toggle group
- Super + Alt + G: remove from group
- Super + Alt + Arrow: join nearby group
- Super + Alt + Tab: cycle grouped windows
- Super + Ctrl + Left/Right: navigate grouped windows

### Required helper replacements

We need Nix-native implementations for:

- close all windows
- pop/float/pin active window
- workspace layout toggle
- monitor scaling cycle

## Look and feel audit

Source:

- `default/hypr/looknfeel.conf`

### General

- gaps in: 5
- gaps out: 10
- border size: 2
- layout: dwindle
- tearing disabled
- border resize disabled

### Borders

- Active border is a green/blue gradient.
- Inactive border is translucent gray.
- Theme may override the active border values.

### Decoration

- Window rounding: 0
- Shadows enabled with a small range
- Blur enabled
- Blur size: 2
- Blur passes: 2
- Special workspaces are blurred
- Blur brightness: 0.60
- Blur contrast: 0.75

### Animations

- Window opening uses a pop-in animation.
- Window closing uses a quick linear pop-out.
- Layer surfaces fade.
- Workspace transitions are disabled.
- Special workspaces slide vertically.

### Layout

- Dwindle preserves splits.
- Dwindle forces split direction.
- Scrolling layout uses approximately half-screen columns.
- Master layout inserts new windows as master.

### Miscellaneous

- Hyprland logo disabled
- Splash rendering disabled
- Scale notification disabled
- Focus-on-activate enabled
- Cursor hides on keyboard input
- Cursor follows workspace changes
- Special workspace hides when changing normal workspaces

## Current parity differences

Our temporary configuration currently differs from Omarchy:

- rounding is currently 8, but Omarchy uses 0
- blur is currently stronger than Omarchy
- border colors are not yet Omarchy themed
- animations are not yet implemented
- only five workspaces are currently bound
- grouping and scratchpad behavior are absent
- multi-monitor workspace movement is absent
- helper-script-dependent bindings are absent

These settings must not be changed yet. They will be replaced atomically after the full Hyprland audit.


