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
