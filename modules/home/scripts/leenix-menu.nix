{
  pkgs,
  variables,
  ...
}:

let
  laptopCap = variables.profiles.laptop or false;
  hyprlandCap = variables.desktop.hyprland or false;
  desktopCap = variables.profiles.desktop or false;
  wifiCap = variables.networking.iwd or false;
  bluetoothCap = variables.hardware.bluetooth or false;

  caps = ''
    LEENIX_CAP_LAPTOP=${
      if laptopCap then "1" else "0"
    }
    LEENIX_CAP_HYPRLAND=${
      if hyprlandCap then "1" else "0"
    }
    LEENIX_CAP_DESKTOP=${
      if desktopCap then "1" else "0"
    }
    LEENIX_CAP_WIFI=${
      if wifiCap then "1" else "0"
    }
    LEENIX_CAP_BLUETOOTH=${
      if bluetoothCap then "1" else "0"
    }
  '';
in

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu";
      excludeShellChecks = [ "SC1090" "SC2086" "SC2155" "SC1091" "SC2034" ];

      runtimeInputs = with pkgs; [
        bash
        coreutils
        findutils
        gnugrep
        gnused
        gawk
        procps
        util-linux
        jq
        gum
        walker
        hyprland
        systemd
        libnotify
        power-profiles-daemon
        brightnessctl
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=LEENIX control center

        ${caps}

        BACK_TO_EXIT=false

        back_to() {
          local parent_menu="$1"
          if [[ $BACK_TO_EXIT == "true" ]]; then
            exit 0
          elif [[ -n $parent_menu ]]; then
            "$parent_menu"
          else
            show_main_menu
          fi
        }

        toggle_existing_menu() {
          if pgrep -f "walker.*--dmenu" >/dev/null; then
            walker --close >/dev/null 2>&1
            # A menu can run as an independent (non-service) instance; give the
            # service-close a moment, then terminate any remaining menu picker.
            sleep 0.2
            pkill -f "walker.*--dmenu" 2>/dev/null || true
            exit 0
          fi
        }

        menu() {
          local prompt="$1"
          local options="$2"
          local extra=''${3:-}
          local preselect=''${4:-}
          read -r -a args <<<"$extra"

          # Sanitize: Walker's dmenu reader STOPS at the first empty stdin line,
          # so drop only truly blank/whitespace-only lines. Valid label content
          # is never trimmed or normalized. The SAME sanitized set drives the
          # preselect index, the dynamic width and Walker's stdin, so they can
          # never diverge.
          local sanitized
          sanitized=$(printf '%b' "$options" | sed '/^[[:space:]]*$/d' || true)

          if [[ -n $preselect ]]; then
            local index
            index=$(printf '%s\n' "$sanitized" | grep -nxF "$preselect" | cut -d: -f1 || true)
            [[ -n $index ]] && args+=("-c" "$index")
          fi
          # Lifecycle: run walker directly — never start/stop the persistent
          # app-launcher service — with -e (exit after this dmenu call) so the
          # panel ALWAYS closes after a selection or Escape. Width is content-
          # sized per invocation from the longest label (leenix-menu-width).
          local width
          width=$(printf '%s\n' "$sanitized" | leenix-menu-width 2>/dev/null || echo 400)
          printf '%s\n' "$sanitized" | walker --dmenu -t leenix-menu --width "$width" --minheight 1 --maxheight 720 -e -p "$prompt…" "''${args[@]}" 2>/dev/null
        }

        terminal() {
          xdg-terminal-exec --app-id=org.leenix.terminal "$@"
        }

        present_terminal() {
          leenix-launch-floating-terminal-with-presentation $1
        }

        # ------------------------------------------------------------ TOGGLES
        # Toggles is split into two capability groups:
        #   Devices         - hardware-related (Displays, Touchpad, Keyboard
        #                     Backlight, Caps Lock, Cameras)
        #   UI/UX Behavior  - desktop/session behavior (Screensaver, Automatic
        #                     Lock, Night Light, Notifications, Waybar,
        #                     Workspace Layout, Window Gaps, 1-Window Ratio)
        show_toggles_menu() {
          case $(menu "Toggles" "󰓩  Devices\n󰄜  UI/UX Behavior") in
          *Devices*) show_devices_menu ;;
          *Behavior*) show_behavior_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_devices_menu() {
          local options=""
          if [[ $LEENIX_CAP_HYPRLAND == "1" ]]; then options="$options󰹉  Displays"; fi
          if [[ $LEENIX_CAP_LAPTOP == "1" ]] && leenix-hw-touchpad; then
            local tp
            tp=$(leenix-toggle-touchpad status | sed -n 's/^desired: //p')
            if [[ $tp == "disabled" ]]; then options="$options\n󰟸  Enable Touchpad"; else options="$options\n󰟸  Disable Touchpad"; fi
          fi
          if [[ $LEENIX_CAP_LAPTOP == "1" ]]; then
            options="$options\n󰌌  Keyboard Backlight"
          fi
          if [[ $LEENIX_CAP_HYPRLAND == "1" ]]; then
            local cl
            cl=$(leenix-capslock status 2>/dev/null | head -1)
            if [[ $cl == "on" ]]; then
              options="$options\n󰌌  Disable Caps Lock"
            else
              options="$options\n󰌌  Enable Caps Lock"
            fi
            options="$options\n󰁷  Cameras"
          fi

          case $(menu "Devices" "$options") in
          *Displays*) show_displays_menu ;;
          *Enable*Touchpad*) leenix-toggle-touchpad on ;;
          *Disable*Touchpad*) leenix-toggle-touchpad off ;;
          *Keyboard*) show_keyboard_backlight_menu ;;
          *Enable*Caps*Lock*) leenix-capslock on ;;
          *Disable*Caps*Lock*) leenix-capslock off ;;
          *Cameras*) show_cameras_menu ;;
          *) back_to show_toggles_menu ;;
          esac
        }

        show_behavior_menu() {
          local options=""
          if [[ $LEENIX_CAP_HYPRLAND == "1" ]]; then
            options="$options󱄄  Screensaver"
            options="$options\n󰍁  Automatic Lock"
            options="$options\n󰛨  Night Light"
            options="$options\n󰂚  Notifications"
            options="$options\n󰍜  Waybar"
            options="$options\n󱂬  Workspace Layout"
            options="$options\n  Window Gaps"
            options="$options\n󰄖  1-Window Ratio"
          fi

          case $(menu "UI/UX Behavior" "$options") in
          *Screensaver*) leenix-toggle-screensaver ;;
          *Automatic*Lock*) leenix-toggle-idle ;;
          *Night*Light*) leenix-toggle-nightlight ;;
          *Notifications*) leenix-toggle-notification-silencing ;;
          *Waybar*) leenix-toggle-waybar ;;
          *Workspace*Layout*) leenix-hyprland-workspace-layout-toggle ;;
          *Window*Gaps*) leenix-hyprland-window-gaps-toggle ;;
          *1-Window*Ratio*) leenix-hyprland-window-single-square-aspect-toggle ;;
          *) back_to show_toggles_menu ;;
          esac
        }

        show_displays_menu() {
          local list="" first=1 monitors name desc action
          # `monitors all` includes physically-connected outputs that are
          # currently disabled, so disabled monitors can be re-enabled here.
          monitors=$(hyprctl monitors all -j | jq -r --arg f "FALLBACK" '.[] | select(.name != $f) | [.name, (.description // "")] | @tsv' 2>/dev/null)
          while IFS=$'\t' read -r name desc; do
            [[ -z $name ]] && continue
            action=$(leenix-monitor status "$name" 2>/dev/null | sed -n 's/^desired: //p')
            if [[ $action == "disabled" ]]; then
              entry="󰍹  Enable ''${desc:-''$name} · $name"
            else
              entry="󰍹  Disable ''${desc:-''$name} · $name"
            fi
            # Never emit a leading empty line (Walker stops at the first one).
            if ((first == 1)); then
              list="$entry"
              first=0
            else
              list="$list\n$entry"
            fi
          done <<<"$monitors"

          local selection
          selection=$(menu "Displays" "$list")
          local mon
          mon=$(echo "$selection" | grep -oE '· [A-Za-z0-9-]+$' | tr -d '· ' || true)
          if [[ $selection == *"Enable "* && -n $mon ]]; then
            leenix-monitor enable "$mon"
          elif [[ $selection == *"Disable "* && -n $mon ]]; then
            leenix-monitor disable "$mon"
          else
            back_to show_toggles_menu
          fi
        }

        show_keyboard_backlight_menu() {
          local dev=""
          for candidate in /sys/class/leds/*kbd_backlight*; do
            [[ -e $candidate ]] && { dev="$(basename "$candidate")"; break; }
          done
          if [[ -z $dev ]]; then
            notify-send -u low "No keyboard backlight device found" 2>/dev/null
            back_to show_toggles_menu
            return
          fi
          local max cur i opts="" first=1
          max=$(cat "/sys/class/leds/$dev/max_brightness" 2>/dev/null || echo 1)
          cur=$(cat "/sys/class/leds/$dev/brightness" 2>/dev/null || echo 0)
          for ((i = 0; i <= max; i++)); do
            if ((i == 0)); then label="Off"; elif ((i == max)); then label="Max"; else label="Step $i"; fi
            # Never emit a leading empty line (Walker stops at the first one).
            if ((first == 1)); then
              opts="󰌌  $label"
              first=0
            else
              opts="$opts\n󰌌  $label"
            fi
          done
          local curlabel="Off"
          [[ $cur -eq $max ]] && curlabel="Max"
          [[ $cur -gt 0 && $cur -lt $max ]] && curlabel="Step $cur"
          local selection
          selection=$(menu "Keyboard Backlight" "$opts" "" "󰌌  $curlabel")
          local level
          case "$selection" in
          *"Off") level=0 ;;
          *"Max") level=$max ;;
          *"Step "*) level=$(echo "$selection" | grep -oE 'Step [0-9]+' | awk '{print $2}') ;;
          *) back_to show_toggles_menu ;;
          esac
          [[ -n $level ]] || { back_to show_toggles_menu; return; }
          # Actually set the hardware brightness, persist desired level, then OSD.
          if brightnessctl -d "$dev" set "$level" >/dev/null 2>&1; then
            leenix-state set "hardware/keyboard-backlight" "$level" 2>/dev/null || true
          fi
          leenix-swayosd-kbd-brightness "$(cat "/sys/class/leds/$dev/brightness" 2>/dev/null || echo 0)" "$max"
        }

        show_cameras_menu() {
          local cameras entries="" first=1 line name
          cameras=$(leenix-camera list 2>/dev/null)
          if [[ -z $cameras ]]; then
            notify-send -u low "No cameras detected" 2>/dev/null
            back_to show_devices_menu
            return
          fi
          # One entry per physical camera (display name) + a general viewer.
          while IFS= read -r line; do
            [[ -z $line ]] && continue
            name=$(echo "$line" | sed -E 's/^[^ ]+ +//; s/ *\((on|off|unknown)\)$//' || true)
            [[ -n $name ]] || continue
            if ((first == 1)); then
              entries="󰁷  $name"
              first=0
            else
              entries="$entries\n󰁷  $name"
            fi
          done <<<"$cameras"
          entries="$entries\n󰗃  Open Camera Viewer"

          local selection
          selection=$(menu "Cameras" "$entries")
          if [[ -n $selection && $selection == *"Open Camera Viewer"* ]]; then
            leenix-camera viewer
          elif [[ -n $selection ]]; then
            # Pure navigation: any other selection is a camera name; open its
            # submenu (state is re-queried inside show_camera_menu).
            show_camera_menu "$(echo "$selection" | sed -E 's/^[^ ]+ +//' || true)"
          else
            back_to show_devices_menu
          fi
        }

        show_camera_menu() {
          local name="$1"
          [[ -n $name ]] || { back_to show_cameras_menu; return; }
          local state
          state=$(leenix-camera status "$name" 2>/dev/null | sed -n 's/^effective: //p')
          if [[ $state == "on" ]]; then
            case $(menu "$name" "󰭦  Preview\n󰁷  Disable") in
            *Preview*) leenix-camera preview "$name" ;;
            *Disable*) leenix-camera disable "$name" ;;
            *) back_to show_cameras_menu ;;
            esac
          else
            case $(menu "$name" "󰁷  Enable") in
            *Enable*) leenix-camera enable "$name" ;;
            *) back_to show_cameras_menu ;;
            esac
          fi
        }

        # ------------------------------------------------------------ NETWORK
        show_network_menu() {
          local options="󰇫  DNS"
          [[ $LEENIX_CAP_WIFI == "1" ]] && options="$options\n  Wi-Fi"
          [[ $LEENIX_CAP_BLUETOOTH == "1" ]] && options="$options\n󰂯  Bluetooth"
          options="$options\n󰁾  Tailscale"
          options="$options\n󰑩  SSH"
          if [[ $LEENIX_CAP_DESKTOP == "1" ]]; then options="$options\n󰣹  LocalSend"; fi
          if [[ $LEENIX_CAP_WIFI == "1" || $LEENIX_CAP_BLUETOOTH == "1" ]]; then options="$options\n󰖑  Airplane Mode"; fi

          case $(menu "Network" "$options") in
          *DNS*) leenix-config-dns ;;
          *Wi-Fi*) leenix-launch-wifi ;;
          *Bluetooth*) leenix-launch-bluetooth ;;
          *Tailscale*) show_tailscale_menu ;;
          *SSH*) show_ssh_menu ;;
          *LocalSend*) show_localsend_menu ;;
          *Airplane*) show_airplane_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_tailscale_menu() {
          local action
          if tailscale status --json 2>/dev/null | jq -e '.BackendState == "Running"' >/dev/null; then
            action="󰁿  Disconnect"
          else
            action="󰁰  Connect"
          fi
          case $(menu "Tailscale" "󰵮  Status\n󰣹  Send File\n$action\n󰈀  Node Info") in
          *Status*) present_terminal "leenix-network-tailscale status" ;;
          *"Send File"*) present_terminal "leenix-tailscale-send" ;;
          *Disconnect*) leenix-network-tailscale down ;;
          *Connect*) present_terminal "leenix-network-tailscale up" ;;
          *"Node Info"*) present_terminal "leenix-network-tailscale ip" ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_ssh_menu() {
          local action
          if systemctl is-active --quiet sshd; then
            action="󰛉  Stop SSH"
          else
            action="󰛉  Start SSH"
          fi
          case $(menu "SSH" "󰵮  Status\n$action") in
          *Status*) present_terminal "leenix-ssh status" ;;
          *"Start SSH"*) leenix-ssh start ;;
          *"Stop SSH"*) leenix-ssh stop ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_localsend_menu() {
          case $(menu "LocalSend" "󰣹  Send\n󰣹  Receive\n󰤆  Quit") in
          *Send*) leenix-menu-share file ;;
          *Receive*) localsend --headless receive &
            ;;
          *Quit*) pkill -x localsend_app 2>/dev/null; pkill -x localsend 2>/dev/null ;;
          *) back_to show_network_menu ;;
          esac
        }

        show_airplane_menu() {
          local action
          if leenix-airplane status | grep -q 'airplane: on'; then
            action="󰖑  Turn Off"
          else
            action="󰖑  Turn On"
          fi
          case $(menu "Airplane Mode" "$action\n󰵮  Status") in
          *"Turn On"*) present_terminal "leenix-airplane on" ;;
          *"Turn Off"*) present_terminal "leenix-airplane off" ;;
          *Status*) present_terminal "leenix-airplane status" ;;
          *) back_to show_network_menu ;;
          esac
        }

        # ------------------------------------------------------------ CAPTURE
        show_capture_menu() {
          case $(menu "Capture" "󰽵  Screen Record\n󰾲  Screenshot\n󰑜  Text Extraction\n󰏘  Color Picker") in
          *Screen*Record*) show_screenrecord_menu ;;
          *Screenshot*) leenix-capture-screenshot ;;
          *Text*) leenix-capture-text-extraction ;;
          *Color*) pkill hyprpicker || hyprpicker -a ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_screenrecord_menu() {
          leenix-capture-screenrecording --stop-recording && exit 0
          case $(menu "Screen Record" "󰽵  Desktop Only\n󰽵  Desktop + Audio\n󰽵  Desktop + Audio + Microphone\n󰽵  Desktop + Audio + Microphone + Webcam") in
          *"Desktop Only") leenix-capture-screenrecording ;;
          *"Desktop + Audio") leenix-capture-screenrecording --with-desktop-audio ;;
          *"Desktop + Audio + Microphone") leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio ;;
          *"Desktop + Audio + Microphone + Webcam") leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio --with-webcam ;;
          *) back_to show_capture_menu ;;
          esac
        }

        # ------------------------------------------------------------ STYLE
        show_style_menu() {
          local options="󰋼  Background\n󰸉  Screensaver Text"
          case $(menu "Style" "$options") in
          *Background*) show_background_menu ;;
          *Screensaver*Text*) show_screensaver_text_menu ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_screensaver_text_menu() {
          case $(menu "Screensaver Text" "󰸉  Show Current\n󰸉  Set Text\n󰋼  Reset to LEENIX Logo") in
          *"Show Current"*) present_terminal "leenix-screensaver-text show" ;;
          *"Set Text"*) present_terminal "leenix-screensaver-text set" ;;
          *"Reset"*) leenix-screensaver-text reset ;;
          *) back_to show_style_menu ;;
          esac
        }

        show_background_menu() {
          case $(menu "Background" "󰋼  Choose Wallpaper\n󰁅  Next\n󰁈  Previous\n󰅒  Random\n󰉋  Open Folder\n󰌑  Refresh\n󰕮  Current") in
          *Choose*) leenix-wallpaper-switcher ;;
          *Next*) leenix-wallpaper-next ;;
          *Previous*) leenix-wallpaper-prev ;;
          *Random*) leenix-wallpaper-random ;;
          *Folder*) leenix-wallpaper-install ;;
          *Refresh*) leenix-wallpaper-refresh ;;
          *Current*) leenix-wallpaper-current ;;
          *) back_to show_style_menu ;;
          esac
        }

        # ------------------------------------------------------------ SETUP
        show_setup_menu() {
          local options="󰊤  Passwordless Sudo\n󰧑  Language\n󰍛  Region & Formats\n󰥔  Timezone"
          [[ $LEENIX_CAP_HYPRLAND == "1" ]] && options="$options\n󰹉  Configure Displays"
          case $(menu "Setup" "$options") in
          *Passwordless*) show_passwordless_menu ;;
          *Language*) leenix-config-language language ;;
          *Region*) leenix-config-language region ;;
          *Timezone*) leenix-config-timezone ;;
          *Displays*) terminal hyprmon
            ;;
          *) back_to show_main_menu ;;
          esac
        }

        show_passwordless_menu() {
          local action
          if leenix-config sudo-passwordless status 2>/dev/null | grep -q enabled; then
            action="󰊤  Disable Passwordless Sudo"
          else
            action="󰊤  Enable Passwordless Sudo"
          fi
          case $(menu "Passwordless Sudo" "$action") in
          *"Enable"*) present_terminal "leenix-config sudo-passwordless on" ;;
          *"Disable"*) present_terminal "leenix-config sudo-passwordless off" ;;
          *) back_to show_setup_menu ;;
          esac
        }

        # ------------------------------------------------------------ POWER
        show_power_menu() {
          local profile
          profile=$(menu "Power" "$(leenix-powerprofiles-list)" "" "$(powerprofilesctl get)")
          if [[ -n $profile && $profile != "CNCLD" ]]; then
            leenix-powerprofiles-set "$profile"
          fi
        }

        # ------------------------------------------------------------ SYSTEM
        show_system_menu() {
          local options="󱄄  Screensaver\n󰌾  Lock\n󰒲  Suspend"
          leenix-hibernation-available 2>/dev/null && options="$options\n󰤁  Hibernate"
          options="$options\n󰍃  Logout\n󰜉  Reboot\n󰐥  Shutdown"
          case $(menu "System" "$options") in
          *Screensaver*) leenix-launch-screensaver force ;;
          *Lock*) leenix-system-lock ;;
          *Suspend*) systemctl suspend ;;
          *Hibernate*) systemctl hibernate ;;
          *Logout*) leenix-system-logout ;;
          *Reboot*) leenix-system-reboot ;;
          *Shutdown*) leenix-system-shutdown ;;
          *) back_to show_main_menu ;;
          esac
        }

        # ------------------------------------------------------------ MAIN
        show_main_menu() {
          go_to_menu "$(menu "LEENIX" "󰣩  Apps\n󰘦  Toggles\n󰇫  Network\n󰾲  Capture\n󰧑  Style\n󰒓  Setup\n󰐥  Power\n󰜼  About\n󰤆  System")"
        }

        go_to_menu() {
          case "''${1,,}" in
          *apps*) leenix-launch-walker >/dev/null 2>&1 &
            exit 0
            ;;
          *toggles*|*hardware*) show_toggles_menu ;;
          *theme*|*style*) show_style_menu ;;
          *network*) show_network_menu ;;
          *capture*) show_capture_menu ;;
          *screenrecord*) show_screenrecord_menu ;;
          *setup*) show_setup_menu ;;
          *power*) show_power_menu ;;
          *about*) leenix-launch-about ;;
          *system*) show_system_menu ;;
          *share*) leenix-menu-share file ;;
          *reminder*set*) leenix-reminder set ;;
          *)
            # Escape on the MAIN menu returns an empty/CNCLD selection: close the
            # menu instead of re-opening it. (Submenus return to their parent via
            # their own `back_to <parent>` default cases.)
            [[ -z ''${1:-} || ''${1,,} == "cncld" ]] && exit 0
            back_to show_main_menu
            ;;
          esac
        }

        USER_EXTENSIONS="$HOME/.config/leenix/extensions/menu.sh"
        [[ -f $USER_EXTENSIONS ]] && source "$USER_EXTENSIONS"

        toggle_existing_menu

        if [[ -n ''${1:-} ]]; then
          BACK_TO_EXIT=true
          go_to_menu "$1"
        else
          show_main_menu
        fi
      '';
    })
  ];
}
