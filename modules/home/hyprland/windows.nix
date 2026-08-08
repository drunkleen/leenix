{ ... }:

{
  home.file.".config/hypr/windows.conf" = {
    executable = true;

    text = ''
# See https://wiki.hypr.land/Configuring/Basics/Window-Rules/ for more
# Hyprland 0.53+ syntax
windowrule = suppress_event maximize, match:class .*

# Tag all windows for default opacity (apps can override with -default-opacity tag)
windowrule = tag +default-opacity, match:class .*

# Fix some dragging issues with XWayland
windowrule = no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0

# Bitwarden
windowrule = no_screen_share on, match:class ^([b|B]itwarden)$
windowrule = tag +floating-window, match:class ^([b|B]itwarden)$

windowrule = no_screen_share on, match:class chrome-nngceckbapebfimnlniiiahkandclblb-Default
windowrule = tag +floating-window, match:class chrome-nngceckbapebfimnlniiiahkandclblb-Default

windowrule = no_screen_share on, match:class firefox-nngceckbapebfimnlniiiahkandclblb-Default
windowrule = tag +floating-window, match:class firefox-nngceckbapebfimnlniiiahkandclblb-Default

# Browser types
windowrule = tag +chromium-based-browser, match:class ((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)
windowrule = tag +firefox-based-browser, match:class ([fF]irefox|zen|librewolf)
windowrule = tag -default-opacity, match:tag chromium-based-browser
windowrule = tag -default-opacity, match:tag firefox-based-browser

# Video apps: remove chromium browser tag so they don't get opacity applied
windowrule = tag -chromium-based-browser, match:class (chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)
windowrule = tag -default-opacity, match:class (chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)

# Force chromium-based browsers into a tile to deal with --app bug
windowrule = tile on, match:tag chromium-based-browser

# Only a subtle opacity change, but not for video sites
windowrule = opacity 1.0 0.985, match:tag chromium-based-browser
windowrule = opacity 1.0 0.985, match:tag firefox-based-browser

# Hide the screen-sharing notification bar (the "Hide" button on it is broken on Wayland)
windowrule = workspace special silent, match:title .*is sharing.*
"sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

windowrule {
  name = geforce
  match:class = GeForceNOW
  idle_inhibit = fullscreen
}

# Remove 1px border around hyprshot screenshots
layerrule = no_anim on, match:namespace selection

# Disable mouse focus (see https://github.com/basecamp/omarchy/pull/5183#issuecomment-4189299971)
windowrule {
    name = jetbrains-focus
    no_follow_mouse = on
    match:class = ^(jetbrains-.*)$
}

# Float LocalSend and fzf file picker
windowrule = float on, match:class (Share|localsend)
windowrule = center on, match:class (Share|localsend)
windowrule = size 1100 700, match:class localsend

windowrule {
  name = moonlight
  match:class = com.moonlight_stream.Moonlight
  fullscreen = 1
  idle_inhibit = fullscreen
}

# Picture-in-picture overlays
windowrule = tag +pip, match:title (Picture.?in.?[Pp]icture)
windowrule = tag -default-opacity, match:tag pip
windowrule = float on, match:tag pip
windowrule = pin on, match:tag pip
windowrule = size 600 338, match:tag pip
windowrule = keep_aspect_ratio on, match:tag pip
windowrule = border_size 0, match:tag pip
windowrule = opacity 1 1, match:tag pip
windowrule = move (monitor_w-window_w-40) (monitor_h*0.04), match:tag pip

windowrule = tag -default-opacity, match:class qemu
windowrule = opacity 1 1, match:class qemu

windowrule = fullscreen on, match:class com.libretro.RetroArch
windowrule = tag -default-opacity, match:class com.libretro.RetroArch
windowrule = opacity 1 1, match:class com.libretro.RetroArch
windowrule = idle_inhibit fullscreen, match:class com.libretro.RetroArch

# Float Steam
windowrule = float on, match:class steam
windowrule = center on, match:class steam, match:title Steam
windowrule = tag -default-opacity, match:class steam.*
windowrule = opacity 1 1, match:class steam.*
windowrule = size 1100 700, match:class steam, match:title Steam
windowrule = size 460 800, match:class steam, match:title Friends List
windowrule = idle_inhibit fullscreen, match:class steam

# Floating windows
windowrule = float on, match:tag floating-window
windowrule = center on, match:tag floating-window
windowrule = size 875 600, match:tag floating-window

windowrule = tag +floating-window, match:class (org.omarchy.bluetui|org.omarchy.impala|org.omarchy.wiremix|org.omarchy.btop|org.omarchy.terminal|org.omarchy.bash|org.codeberg.dnkl.foot|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|Omarchy|About|TUI.float|imv|mpv)
windowrule = tag +floating-window, match:class (xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus), match:title ^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)
windowrule = float on, match:class org.gnome.Calculator

# Fullscreen screensaver
windowrule = fullscreen on, match:class org.omarchy.screensaver
windowrule = float on, match:class org.omarchy.screensaver
windowrule = animation slide, match:class org.omarchy.screensaver

# No transparency on media windows
windowrule = tag -default-opacity, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$
windowrule = opacity 1 1, match:class ^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$

# Popped window rounding
windowrule = rounding 8, match:tag pop

# Prevent idle while open
windowrule = idle_inhibit always, match:tag noidle

# Prevent Telegram from stealing focus on new messages
windowrule = focus_on_activate off, match:class org.telegram.desktop

# Define terminal tag to style them uniformly
windowrule = tag +terminal, match:class (Alacritty|kitty|com.mitchellh.ghostty|foot)
windowrule = tag -default-opacity, match:tag terminal
windowrule = opacity 0.985 0.96, match:tag terminal

# Application-specific animation
layerrule = no_anim on, match:namespace walker

# Webcam overlay for screen recording
windowrule = float on, match:title WebcamOverlay
windowrule = pin on, match:title WebcamOverlay
windowrule = no_initial_focus on, match:title WebcamOverlay
windowrule = no_dim on, match:title WebcamOverlay
windowrule = move (monitor_w-window_w-40) (monitor_h-window_h-40), match:title WebcamOverlay

# Apply default opacity after apps have had a chance to opt out
windowrule = opacity 0.985 0.96, match:tag default-opacity

    '';
  };
}
