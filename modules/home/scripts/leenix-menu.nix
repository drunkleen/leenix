{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-menu";
      excludeShellChecks = [ "SC1090" "SC2086" "SC2155" ];

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
      ];

      text = ''
        #!/bin/bash
        
        # leenix:summary=Launch the Leenix Menu or takes a parameter to jump straight to a submenu.
        
        # Set to true when going directly to a submenu, so we can exit directly
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
            exit 0
          fi
        }
        
        menu() {
          local prompt="$1"
          local options="$2"
          local extra=''${3:-}
          local preselect=''${4:-}
        
          read -r -a args <<<"$extra"
        
          if [[ -n $preselect ]]; then
            local index
            index=$(echo -e "$options" | grep -nxF "$preselect" | cut -d: -f1)
            if [[ -n $index ]]; then
              args+=("-c" "$index")
            fi
          fi
        
          echo -e "$options" | leenix-launch-walker --dmenu --width 295 --minheight 1 --maxheight 630 -p "$prompt…" "''${args[@]}" 2>/dev/null
        }
        
        terminal() {
          xdg-terminal-exec --app-id=org.leenix.terminal "$@"
        }
        
        present_terminal() {
          leenix-launch-floating-terminal-with-presentation $1
        }
        
        open_in_editor() {
          notify-send -u low "Editing config file" "$1"
          leenix-launch-editor "$1"
        }
        
        install() {
          present_terminal "echo 'Installing $1...'; leenix-pkg-add $2"
        }
        
        install_and_launch() {
          present_terminal "echo 'Installing $1...'; leenix-pkg-add $2 && setsid gtk-launch $3"
        }
        
        install_font() {
          present_terminal "echo 'Installing $1...'; leenix-pkg-add $2 && sleep 2 && leenix-font-set '$3'"
        }
        
        install_terminal() {
          present_terminal "leenix-install-terminal $1"
        }
        
        aur_install() {
          present_terminal "echo 'Installing $1 from AUR...'; leenix-pkg-aur-add $2"
        }
        
        aur_install_and_launch() {
          present_terminal "echo 'Installing $1 from AUR...'; leenix-pkg-aur-add $2 && setsid gtk-launch $3"
        }
        
        show_learn_menu() {
          case $(menu "Learn" "  Keybindings\n  Leenix\n  Hyprland\n󰣇  Arch\n  Neovim\n󱆃  Bash") in
          *Keybindings*) leenix-menu-keybindings ;;
          *Leenix*) leenix-launch-browser "https://learn.omacom.io/2/the-leenix-manual" ;;
          *Hyprland*) leenix-launch-browser "https://wiki.hypr.land/" ;;
          *Arch*) leenix-launch-browser "https://wiki.archlinux.org/title/Main_page" ;;
          *Bash*) leenix-launch-browser "https://devhints.io/bash" ;;
          *Neovim*) leenix-launch-browser "https://www.lazyvim.org/keymaps" ;;
          *) show_main_menu ;;
          esac
        }
        
        show_trigger_menu() {
          case $(menu "Trigger" "󰔛  Reminder\n  Capture\n󰧸  Transcode\n  Share\n󰔎  Toggle\n  Hardware") in
          *Reminder*) show_reminder_menu ;;
          *Capture*) show_capture_menu ;;
          *Transcode*) leenix-transcode || back_to show_trigger_menu ;;
          *Share*) show_share_menu ;;
          *Toggle*) show_toggle_menu ;;
          *Hardware*) show_hardware_menu ;;
          *) show_main_menu ;;
          esac
        }
        
        show_reminder_menu() {
          case $(menu "Reminder" "󰔛  Set one\n󰔛  Show all\n󰔛  Clear all") in
          *Set*) show_custom_reminder_input ;;
          *"Show all"*) leenix-reminder show ;;
          *"Clear all"*) leenix-reminder clear ;;
          *) back_to show_trigger_menu ;;
          esac
        }
        
        show_custom_reminder_input() {
          local minutes
          minutes=$(leenix-menu-input "Remind in minutes")
        
          if [[ $minutes =~ ^[0-9]+$ ]] && ((minutes > 0)); then
            show_reminder_message_input "$minutes"
          elif [[ -n $minutes ]]; then
            leenix-notification-send "󰔛" "Invalid reminder" "Enter the number of minutes" -u critical
            show_custom_reminder_input
          else
            back_to show_reminder_menu
          fi
        }
        
        show_reminder_message_input() {
          local minutes="$1"
          local message
          message=$(leenix-menu-input "Reminder message")
        
          if [[ -n $message ]]; then
            leenix-reminder "$minutes" "$message"
          else
            leenix-reminder "$minutes"
          fi
        }
        
        show_capture_menu() {
          case $(menu "Capture" "  Screenshot\n  Screenrecord\n󰴑  Text Extraction\n󰃉  Color") in
          *Screenshot*) leenix-capture-screenshot ;;
          *Screenrecord*) show_screenrecord_menu ;;
          *Text*) leenix-capture-text-extraction ;;
          *Color*) pkill hyprpicker || hyprpicker -a ;;
          *) back_to show_trigger_menu ;;
          esac
        }
        
        get_webcam_list() {
          v4l2-ctl --list-devices 2>/dev/null | while IFS= read -r line; do
            if [[ $line != $'\t'* && -n $line ]]; then
              local name="$line"
              IFS= read -r device || break
              device=$(echo "$device" | tr -d '\t' | head -1)
              [[ -n $device ]] && echo "$device  $name"
            fi
          done
        }
        
        show_webcam_select_menu() {
          local devices=$(get_webcam_list)
          local count=$(echo "$devices" | grep -c . 2>/dev/null || echo 0)
        
          if [[ -z $devices ]] || ((count == 0)); then
            notify-send "No webcam devices found" -u critical -t 3000
            return 1
          fi
        
          if ((count == 1)); then
            echo "$devices" | awk '{print $1}'
          else
            menu "Select Webcam" "$devices" | awk '{print $1}'
          fi
        }
        
        show_screenrecord_menu() {
          leenix-capture-screenrecording --stop-recording && exit 0
        
          case $(menu "Screenrecord" "  With no audio\n  With desktop audio\n  With desktop + microphone audio\n  With desktop + microphone audio + webcam") in
          *"With no audio") leenix-capture-screenrecording ;;
          *"With desktop audio") leenix-capture-screenrecording --with-desktop-audio ;;
          *"With desktop + microphone audio") leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio ;;
          *"With desktop + microphone audio + webcam")
            local device=$(show_webcam_select_menu) || {
              back_to show_capture_menu
              return
            }
            leenix-capture-screenrecording --with-desktop-audio --with-microphone-audio --with-webcam --webcam-device="$device"
            ;;
          *) back_to show_capture_menu ;;
          esac
        }
        
        show_share_menu() {
          case $(menu "Share" "  Clipboard\n  File \n  Folder") in
          *Clipboard*) leenix-menu-share clipboard ;;
          *File*) terminal bash -c "leenix-menu-share file" ;;
          *Folder*) terminal bash -c "leenix-menu-share folder" ;;
          *) back_to show_trigger_menu ;;
          esac
        }
        
        show_toggle_menu() {
          local options="󱄄  Screensaver\n󰔎  Nightlight\n󱫖  Idle Lock\n󰂛  Notifications\n󰍜  Top Bar\n󱂬  Workspace Layout\n  Window Gaps\n  1-Window Ratio\n󰍹  Monitor Scaling\n  Direct Boot\n󰟵  Passwordless Sudo"
        
          case $(menu "Toggle" "$options") in
          *Screensaver*) leenix-toggle-screensaver ;;
          *Nightlight*) leenix-toggle-nightlight ;;
          *Idle*) leenix-toggle-idle ;;
          *Notifications*) leenix-toggle-notification-silencing ;;
          *Bar*) leenix-toggle-waybar ;;
          *Layout*) leenix-hyprland-workspace-layout-toggle ;;
          *Ratio*) leenix-hyprland-window-single-square-aspect-toggle ;;
          *Gaps*) leenix-hyprland-window-gaps-toggle ;;
          *Scaling*) leenix-hyprland-monitor-scaling-cycle ;;
          *"Direct Boot"*) present_terminal leenix-config-direct-boot ;;
          *"Passwordless Sudo"*) present_terminal leenix-sudo-passwordless ;;
          *) back_to show_trigger_menu ;;
          esac
        }
        
        show_hardware_menu() {
          local lap_action="Disable Laptop Monitor"
          [[ $(leenix-monitor-laptop status 2>/dev/null | sed -n 's/^desired: //p') == "disabled" ]] && lap_action="Enable Laptop Monitor"
          local options="󰛧  $lap_action\n󰍹  Mirror Display"
        
          if leenix-hw-hybrid-gpu; then
            options="$options\n  Hybrid GPU"
          fi
        
          if leenix-hw-touchpad; then
            options="$options\n󰟸  Touchpad"
          fi
        
          if leenix-hw-dell-xps-haptic-touchpad && leenix-cmd-present dell-xps-touchpad-haptics; then
            options="$options\n󰌌  Touchpad Haptics"
          fi
        
          if leenix-hw-touchscreen; then
            options="$options\n󰆽  Touchscreen"
          fi
        
          case $(menu "Hardware" "$options") in
          *Disable*Laptop*) leenix-monitor-laptop disable ;;
          *Enable*Laptop*) leenix-monitor-laptop enable ;;
          *Mirror*) leenix-hyprland-monitor-internal-mirror toggle ;;
          *Haptics*) show_hardware_touchpad_haptics_menu ;;
          *Touchpad*) leenix-toggle-touchpad ;;
          *Touchscreen*) leenix-toggle-touchscreen ;;
          *"Hybrid GPU"*) present_terminal leenix-toggle-hybrid-gpu ;;
          *) back_to show_trigger_menu ;;
          esac
        }
        
        show_hardware_touchpad_haptics_menu() {
          local current=$(dell-xps-touchpad-haptics get)
          local selected=$(menu "Touchpad Haptics" "low\nmid\nhigh" "" "$current")
        
          if [[ -n $selected ]]; then
            dell-xps-touchpad-haptics set "$selected"
          else
            back_to show_hardware_menu
          fi
        }
        
        show_style_menu() {
          case $(menu "Style" "󰸌  Theme\n󰟵  Unlock\n  Font\n  Background\n  Hyprland\n󱄄  Screensaver\n  About") in
          *Theme*) show_theme_menu ;;
          *Unlock*) leenix-launch-walker -m menus:leenixunlocks --width 800 --minheight 400 ;;
          *Font*) show_font_menu ;;
          *Background*) show_background_menu ;;
          *Hyprland*) open_in_editor ~/.config/hypr/looknfeel.conf ;;
          *Screensaver*) show_screensaver_menu ;;
          *About*) show_about_menu ;;
          *) show_main_menu ;;
          esac
        }
        
        show_about_menu() {
          case $(menu "About" "  Edit Text\n  Set From Image\n  Restore Default") in
          *Text*) leenix-branding-about text ;;
          *Image*) leenix-branding-about image ;;
          *Default*) leenix-branding-about reset ;;
          *) show_style_menu ;;
          esac
        }
        
        show_screensaver_menu() {
          case $(menu "Screensaver" "  Edit Text\n  Set From Image\n  Restore Default") in
          *Text*) leenix-branding-screensaver text ;;
          *Image*) leenix-branding-screensaver image ;;
          *Default*) leenix-branding-screensaver reset ;;
          *) show_style_menu ;;
          esac
        }
        
        show_theme_menu() {
          leenix-launch-walker -m menus:leenixthemes --width 800 --minheight 400
        }
        
        show_background_menu() {
          case $(menu "Background" "󰋼  Choose Wallpaper\n󰁅  Next\n󰁈  Previous\n  Random\n󰉋  Open Folder\n  Refresh\n󰕮  Current") in
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
        
        show_font_menu() {
          theme=$(menu "Font" "$(leenix-font-list)" "--width 350" "$(leenix-font-current)")
          if [[ $theme == "CNCLD" || -z $theme ]]; then
            back_to show_style_menu
          else
            leenix-font-set "$theme"
          fi
        }
        
        show_setup_menu() {
          local options="  Audio\n  Wifi\n󰂯  Bluetooth\n󱐋  Power Profile\n  System Sleep\n󰍹  Monitors"
          [[ -f ~/.config/hypr/bindings.conf ]] && options="$options\n  Keybindings"
          [[ -f ~/.config/hypr/input.conf ]] && options="$options\n  Input"
          options="$options\n  Defaults\n󰱔  DNS\n  Security\n  Config"
        
          case $(menu "Setup" "$options") in
          *Audio*) leenix-launch-audio ;;
          *Wifi*) leenix-launch-wifi ;;
          *Bluetooth*) leenix-launch-bluetooth ;;
          *Power*) show_setup_power_menu ;;
          *System*) show_setup_system_menu ;;
          *Monitors*) open_in_editor ~/.config/hypr/monitors.conf ;;
          *Keybindings*) open_in_editor ~/.config/hypr/bindings.conf ;;
          *Input*) open_in_editor ~/.config/hypr/input.conf ;;
          *Defaults*) show_setup_default_menu ;;
          *DNS*) present_terminal leenix-setup-dns ;;
          *Security*) show_setup_security_menu ;;
          *Config*) show_setup_config_menu ;;
          *) show_main_menu ;;
          esac
        }
        
        show_setup_power_menu() {
          profile=$(menu "Power Profile" "$(leenix-powerprofiles-list)" "" "$(powerprofilesctl get)")
        
          if [[ $profile == "CNCLD" || -z $profile ]]; then
            back_to show_setup_menu
          else
            powerprofilesctl set "$profile"
          fi
        }
        
        show_setup_security_menu() {
          case $(menu "Setup" "󰈷  Fingerprint\n  Fido2") in
          *Fingerprint*) present_terminal leenix-setup-security-fingerprint ;;
          *Fido2*) present_terminal leenix-setup-security-fido2 ;;
          *) show_setup_menu ;;
          esac
        }
        
        show_setup_default_menu() {
          case $(menu "Default" "  Terminal\n  Editor") in
          *Terminal*) show_setup_default_terminal_menu ;;
          *Editor*) show_setup_default_editor_menu ;;
          *) show_setup_menu ;;
          esac
        }
        
        show_setup_default_terminal_menu() {
          local options=""
          leenix-cmd-present alacritty && options="$options  Alacritty"
          leenix-cmd-present foot && options="''${options:+$options\n}  Foot"
          leenix-cmd-present ghostty && options="''${options:+$options\n}  Ghostty"
          leenix-cmd-present kitty && options="''${options:+$options\n}  Kitty"
        
          local current=""
          case "$(leenix-default-terminal)" in
          alacritty) current="  Alacritty" ;;
          foot) current="  Foot" ;;
          ghostty) current="  Ghostty" ;;
          kitty) current="  Kitty" ;;
          esac
        
          case $(menu "Default Terminal" "$options" "" "$current") in
          *Alacritty*) leenix-default-terminal alacritty ;;
          *Foot*) leenix-default-terminal foot ;;
          *Ghostty*) leenix-default-terminal ghostty ;;
          *Kitty*) leenix-default-terminal kitty ;;
          *) show_setup_default_menu ;;
          esac
        }
        
        show_setup_default_editor_menu() {
          local options=""
          leenix-cmd-present nvim && options="$options  Neovim"
          leenix-cmd-present code && options="''${options:+$options\n}  VSCode"
          leenix-cmd-present cursor && options="''${options:+$options\n}  Cursor"
          leenix-cmd-present zeditor && options="''${options:+$options\n}  Zed"
          leenix-cmd-present sublime_text && options="''${options:+$options\n}  Sublime Text"
          leenix-cmd-present helix && options="''${options:+$options\n}  Helix"
          leenix-cmd-present vim && options="''${options:+$options\n}  Vim"
          leenix-cmd-present emacs && options="''${options:+$options\n}  Emacs"
        
          local current=""
          case "$(leenix-default-editor)" in
          nvim) current="  Neovim" ;;
          code) current="  VSCode" ;;
          cursor) current="  Cursor" ;;
          zed | zeditor) current="  Zed" ;;
          sublime_text) current="  Sublime Text" ;;
          helix) current="  Helix" ;;
          vim) current="  Vim" ;;
          emacs) current="  Emacs" ;;
          esac
        
          case $(menu "Default Editor" "$options" "" "$current") in
          *Neovim*) leenix-default-editor nvim ;;
          *VSCode*) leenix-default-editor code ;;
          *Cursor*) leenix-default-editor cursor ;;
          *Zed*) leenix-default-editor zed ;;
          *Sublime*) leenix-default-editor sublime_text ;;
          *Helix*) leenix-default-editor helix ;;
          *Vim*) leenix-default-editor vim ;;
          *Emacs*) leenix-default-editor emacs ;;
          *) show_setup_default_menu ;;
          esac
        }
        
        show_setup_config_menu() {
          case $(menu "Setup" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n  Swayosd\n󰌧  Walker\n󰍜  Waybar\n󰞅  XCompose") in
          *Hyprland*) open_in_editor ~/.config/hypr/hyprland.conf ;;
          *Hypridle*) open_in_editor ~/.config/hypr/hypridle.conf && leenix-restart-hypridle ;;
          *Hyprlock*) open_in_editor ~/.config/hypr/hyprlock.conf ;;
          *Hyprsunset*) open_in_editor ~/.config/hypr/hyprsunset.conf && leenix-restart-hyprsunset ;;
          *Swayosd*) open_in_editor ~/.config/swayosd/config.toml && leenix-restart-swayosd ;;
          *Walker*) open_in_editor ~/.config/walker/config.toml && leenix-restart-walker ;;
          *Waybar*) open_in_editor ~/.config/waybar/config && leenix-restart-waybar ;;
          *XCompose*) open_in_editor ~/.XCompose && leenix-restart-xcompose ;;
          *) show_setup_menu ;;
          esac
        }
        
        show_setup_system_menu() {
          local options=""
        
          if leenix-toggle-enabled suspend-off; then
            options="$options󰒲  Enable Suspend"
          else
            options="$options󰒲  Disable Suspend"
          fi
        
          if leenix-hibernation-available; then
            options="$options\n󰤁  Disable Hibernate"
          else
            options="$options\n󰤁  Enable Hibernate"
          fi
        
          case $(menu "System" "$options") in
          *Suspend*) leenix-toggle-suspend ;;
          *"Enable Hibernate"*) present_terminal leenix-hibernation-setup ;;
          *"Disable Hibernate"*) present_terminal leenix-hibernation-remove ;;
          *) show_setup_menu ;;
          esac
        }
        
        show_install_menu() {
          case $(menu "Install" "󰣇  Package\n󰣇  AUR\n  TUI\n  Service\n  Style\n󰵮  Development\n  Editor\n  Terminal\n  Browser\n󱚤  AI\n  Gaming\n󰍲  Windows") in
          *Package*) terminal leenix-pkg-install ;;
          *AUR*) terminal leenix-pkg-aur-install ;;
          *TUI*) present_terminal leenix-tui-install ;;
          *Service*) show_install_service_menu ;;
          *Style*) show_install_style_menu ;;
          *Development*) show_install_development_menu ;;
          *Editor*) show_install_editor_menu ;;
          *Terminal*) show_install_terminal_menu ;;
          *Browser*) show_install_browser_menu ;;
          *Gaming*) show_install_gaming_menu ;;
          *AI*) show_install_ai_menu ;;
          *Windows*) present_terminal "leenix-windows-vm install" ;;
          *) show_main_menu ;;
          esac
        }
        
        show_install_browser_menu() {
          case $(menu "Install" "  Chrome\n  Edge\n  Brave\n  Brave Origin\n  Firefox\n󰖟  Zen") in
          *Chrome*) present_terminal "leenix-install-browser chrome" ;;
          *Edge*) present_terminal "leenix-install-browser edge" ;;
          *"Brave Origin"*) present_terminal "leenix-install-browser brave-origin" ;;
          *Brave*) present_terminal "leenix-install-browser brave" ;;
          *Firefox*) present_terminal "leenix-install-browser firefox" ;;
          *Zen*) present_terminal "leenix-install-browser zen" ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_service_menu() {
          case $(menu "Install" "  Dropbox\n  Tailscale\n󱇱  NordVPN [AUR]\n󰏖  ONCE\n󰟵  Bitwarden\n  Chromium Account") in
          *Dropbox*) present_terminal leenix-install-dropbox ;;
          *Tailscale*) present_terminal leenix-install-tailscale ;;
          *NordVPN*) present_terminal leenix-install-nordvpn ;;
          *ONCE*) present_terminal leenix-install-once ;;
          *Bitwarden*) install_and_launch "Bitwarden" "bitwarden bitwarden-cli" "bitwarden" ;;
          *Chromium*) present_terminal leenix-install-chromium-google-account ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_editor_menu() {
          case $(menu "Install" "  VSCode\n  Cursor\n  Zed\n  Sublime Text\n  Helix\n  Vim\n  Emacs") in
          *VSCode*) present_terminal leenix-install-vscode ;;
          *Cursor*) install_and_launch "Cursor" "cursor-bin" "cursor" ;;
          *Zed*) present_terminal leenix-install-zed ;;
          *Sublime*) install_and_launch "Sublime Text" "sublime-text-4" "sublime_text" ;;
          *Helix*) present_terminal leenix-install-helix ;;
          *Vim*) install "Vim" "vim" ;;
          *Emacs*) install "Emacs" "emacs-wayland" && systemctl --user enable --now emacs.service ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_terminal_menu() {
          case $(menu "Install" "  Alacritty\n  Foot\n  Ghostty\n  Kitty") in
          *Alacritty*) install_terminal "alacritty" ;;
          *Foot*) install_terminal "foot" ;;
          *Ghostty*) install_terminal "ghostty" ;;
          *Kitty*) install_terminal "kitty" ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_ai_menu() {
          ollama_pkg=$(
            (leenix-cmd-present nvidia-smi && echo ollama-cuda) ||
              (leenix-cmd-present rocminfo && echo ollama-rocm) ||
              echo ollama
          )
        
          case $(menu "Install" "  Dictation\n󱚤  LM Studio\n󱚤  Ollama\n󱚤  Crush") in
          *Dictation*) present_terminal leenix-voxtype-install ;;
          *Studio*) install "LM Studio" "lmstudio-bin" ;;
          *Ollama*) install "Ollama" $ollama_pkg ;;
          *Crush*) install "Crush" "crush-bin" ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_gaming_menu() {
          case $(menu "Install" "  Steam\n  RetroArch\n󰍳  Minecraft\n󰢹  NVIDIA GeForce NOW\n  Xbox Cloud Gaming\n󰂯  Xbox Controller\n󰍹  Moonlight (GameStream)\n  Lutris (Battle.net)\n󱓟  Heroic (Epic Games)") in
          *Steam*) present_terminal leenix-install-gaming-steam ;;
          *RetroArch*) present_terminal leenix-install-gaming-retroarch ;;
          *Minecraft*) install_and_launch "Minecraft" "minecraft-launcher" "minecraft-launcher" ;;
          *GeForce*) present_terminal leenix-install-gaming-geforce-now ;;
          *"Xbox Cloud"*) present_terminal leenix-install-gaming-xbox-cloud ;;
          *Xbox*) present_terminal leenix-install-gaming-xbox-controllers ;;
          *Lutris*) present_terminal leenix-install-gaming-lutris ;;
          *Heroic*) present_terminal leenix-install-gaming-heroic ;;
          *Moonlight*) present_terminal leenix-install-gaming-moonlight ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_style_menu() {
          case $(menu "Install" "󰸌  Theme\n  Background\n  Font") in
          *Theme*) present_terminal leenix-theme-install ;;
          *Background*) leenix-wallpaper-install ;;
          *Font*) show_install_font_menu ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_font_menu() {
          case $(menu "Install" "  Cascadia Mono\n  Meslo LG Mono\n  Fira Code\n  Victor Code\n  Bitstream Vera Mono\n  Iosevka" "--width 350") in
          *Cascadia*) install_font "Cascadia Mono" "ttf-cascadia-mono-nerd" "CaskaydiaMono Nerd Font" ;;
          *Meslo*) install_font "Meslo LG Mono" "ttf-meslo-nerd" "MesloLGL Nerd Font" ;;
          *Fira*) install_font "Fira Code" "ttf-firacode-nerd" "FiraCode Nerd Font" ;;
          *Victor*) install_font "Victor Code" "ttf-victor-mono-nerd" "VictorMono Nerd Font" ;;
          *Bitstream*) install_font "Bitstream Vera Code" "ttf-bitstream-vera-mono-nerd" "BitstromWera Nerd Font" ;;
          *Iosevka*) install_font "Iosevka" "ttf-iosevka-nerd" "Iosevka Nerd Font Mono" ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_development_menu() {
          case $(menu "Install" "󰫏  Ruby on Rails\n  Docker DB\n  JavaScript\n  Go\n  PHP\n  Python\n  Elixir\n  Zig\n  Rust\n  Java\n  .NET\n  OCaml\n  Clojure\n  Scala") in
          *Rails*) present_terminal "leenix-install-dev-env ruby" ;;
          *Docker*) present_terminal leenix-install-docker-dbs ;;
          *JavaScript*) show_install_javascript_menu ;;
          *Go*) present_terminal "leenix-install-dev-env go" ;;
          *PHP*) show_install_php_menu ;;
          *Python*) present_terminal "leenix-install-dev-env python" ;;
          *Elixir*) show_install_elixir_menu ;;
          *Zig*) present_terminal "leenix-install-dev-env zig" ;;
          *Rust*) present_terminal "leenix-install-dev-env rust" ;;
          *Java*) present_terminal "leenix-install-dev-env java" ;;
          *NET*) present_terminal "leenix-install-dev-env dotnet" ;;
          *OCaml*) present_terminal "leenix-install-dev-env ocaml" ;;
          *Clojure*) present_terminal "leenix-install-dev-env clojure" ;;
          *Scala*) present_terminal "leenix-install-dev-env scala" ;;
          *) show_install_menu ;;
          esac
        }
        
        show_install_javascript_menu() {
          case $(menu "Install" "  Node.js\n  Bun\n  Deno") in
          *Node*) present_terminal "leenix-install-dev-env node" ;;
          *Bun*) present_terminal "leenix-install-dev-env bun" ;;
          *Deno*) present_terminal "leenix-install-dev-env deno" ;;
          *) show_install_development_menu ;;
          esac
        }
        
        show_install_php_menu() {
          case $(menu "Install" "  PHP\n  Laravel\n  Symfony") in
          *PHP*) present_terminal "leenix-install-dev-env php" ;;
          *Laravel*) present_terminal "leenix-install-dev-env laravel" ;;
          *Symfony*) present_terminal "leenix-install-dev-env symfony" ;;
          *) show_install_development_menu ;;
          esac
        }
        
        show_install_elixir_menu() {
          case $(menu "Install" "  Elixir\n  Phoenix") in
          *Elixir*) present_terminal "leenix-install-dev-env elixir" ;;
          *Phoenix*) present_terminal "leenix-install-dev-env phoenix" ;;
          *) show_install_development_menu ;;
          esac
        }
        
        show_remove_menu() {
          case $(menu "Remove" "󰣇  Package\n  TUI\n󰵮  Development\n󰸌  Theme\n  Browser\n  Dictation\n  Gaming\n󰍲  Windows\n󰏓  Preinstalls\n  Security") in
          *Package*) terminal leenix-pkg-remove ;;
          *TUI*) present_terminal leenix-tui-remove ;;
          *Development*) show_remove_development_menu ;;
          *Theme*) present_terminal leenix-theme-remove ;;
          *Browser*) show_remove_browser_menu ;;
          *Dictation*) present_terminal leenix-voxtype-remove ;;
          *Gaming*) show_remove_gaming_menu ;;
          *Windows*) present_terminal "leenix-windows-vm remove" ;;
          *Preinstalls*) present_terminal leenix-remove-preinstalls ;;
          *Security*) show_remove_security_menu ;;
          *) show_main_menu ;;
          esac
        }
        
        show_remove_security_menu() {
          case $(menu "Remove" "󰈷  Fingerprint\n  Fido2") in
          *Fingerprint*) present_terminal leenix-remove-security-fingerprint ;;
          *Fido2*) present_terminal leenix-remove-security-fido2 ;;
          *) show_remove_menu ;;
          esac
        }
        
        show_remove_browser_menu() {
          case $(menu "Remove" "  Chrome\n  Edge\n  Brave\n  Brave Origin\n  Firefox\n  Zen") in
          *Chrome*) present_terminal "leenix-remove-browser chrome" ;;
          *Edge*) present_terminal "leenix-remove-browser edge" ;;
          *"Brave Origin"*) present_terminal "leenix-remove-browser brave-origin" ;;
          *Brave*) present_terminal "leenix-remove-browser brave" ;;
          *Firefox*) present_terminal "leenix-remove-browser firefox" ;;
          *Zen*) present_terminal "leenix-remove-browser zen" ;;
          *) show_remove_menu ;;
          esac
        }
        
        show_remove_gaming_menu() {
          case $(menu "Remove" "  Steam\n  RetroArch\n󰍳  Minecraft\n󰢹  NVIDIA GeForce NOW\n  Xbox Cloud Gaming\n󰖺  Xbox Controller (󰂯)\n󰍹  Moonlight (GameStream)\n  Lutris (Battle.net)\n󱓟  Heroic (Epic Games)") in
          *Steam*) present_terminal leenix-remove-gaming-steam ;;
          *RetroArch*) present_terminal leenix-remove-gaming-retroarch ;;
          *Minecraft*) present_terminal leenix-remove-gaming-minecraft ;;
          *GeForce*) present_terminal leenix-remove-gaming-geforce-now ;;
          *"Xbox Cloud"*) present_terminal leenix-remove-gaming-xbox-cloud ;;
          *Xbox*) present_terminal leenix-remove-gaming-xbox-controllers ;;
          *Moonlight*) present_terminal leenix-remove-gaming-moonlight ;;
          *Lutris*) present_terminal leenix-remove-gaming-lutris ;;
          *Heroic*) present_terminal leenix-remove-gaming-heroic ;;
          *) show_remove_menu ;;
          esac
        }
        
        show_remove_development_menu() {
          case $(menu "Remove" "󰫏  Ruby on Rails\n  JavaScript\n  Go\n  PHP\n  Python\n  Elixir\n  Zig\n  Rust\n  Java\n  .NET\n  OCaml\n  Clojure\n  Scala") in
          *Rails*) present_terminal "leenix-remove-dev-env ruby" ;;
          *JavaScript*) show_remove_javascript_menu ;;
          *Go*) present_terminal "leenix-remove-dev-env go" ;;
          *PHP*) show_remove_php_menu ;;
          *Python*) present_terminal "leenix-remove-dev-env python" ;;
          *Elixir*) show_remove_elixir_menu ;;
          *Zig*) present_terminal "leenix-remove-dev-env zig" ;;
          *Rust*) present_terminal "leenix-remove-dev-env rust" ;;
          *Java*) present_terminal "leenix-remove-dev-env java" ;;
          *NET*) present_terminal "leenix-remove-dev-env dotnet" ;;
          *OCaml*) present_terminal "leenix-remove-dev-env ocaml" ;;
          *Clojure*) present_terminal "leenix-remove-dev-env clojure" ;;
          *Scala*) present_terminal "leenix-remove-dev-env scala" ;;
          *) show_remove_menu ;;
          esac
        }
        
        show_remove_javascript_menu() {
          case $(menu "Remove" "  Node.js\n  Bun\n  Deno") in
          *Node*) present_terminal "leenix-remove-dev-env node" ;;
          *Bun*) present_terminal "leenix-remove-dev-env bun" ;;
          *Deno*) present_terminal "leenix-remove-dev-env deno" ;;
          *) show_remove_development_menu ;;
          esac
        }
        
        show_remove_php_menu() {
          case $(menu "Remove" "  PHP\n  Laravel\n  Symfony") in
          *PHP*) present_terminal "leenix-remove-dev-env php" ;;
          *Laravel*) present_terminal "leenix-remove-dev-env laravel" ;;
          *Symfony*) present_terminal "leenix-remove-dev-env symfony" ;;
          *) show_remove_development_menu ;;
          esac
        }
        
        show_remove_elixir_menu() {
          case $(menu "Remove" "  Elixir\n  Phoenix") in
          *Elixir*) present_terminal "leenix-remove-dev-env elixir" ;;
          *Phoenix*) present_terminal "leenix-remove-dev-env phoenix" ;;
          *) show_remove_development_menu ;;
          esac
        }
        
        show_update_menu() {
          case $(menu "Update" "  Leenix\n󰔫  Channel\n  Config\n󰸌  Extra Themes\n  Process\n󰇅  Hardware\n  Firmware\n  Password\n  Timezone\n  Time") in
          *Leenix*) present_terminal leenix-update ;;
          *Channel*) show_update_channel_menu ;;
          *Config*) show_update_config_menu ;;
          *Themes*) present_terminal leenix-theme-update ;;
          *Process*) show_update_process_menu ;;
          *Hardware*) show_update_hardware_menu ;;
          *Firmware*) present_terminal leenix-update-firmware ;;
          *Timezone*) present_terminal leenix-tz-select ;;
          *Time*) present_terminal leenix-update-time ;;
          *Password*) show_update_password_menu ;;
          *) show_main_menu ;;
          esac
        }
        
        show_update_channel_menu() {
          case $(menu "Update channel" "🟢 Stable\n🟡 RC\n🟠 Edge\n🔴 Dev") in
          *Stable*) present_terminal "leenix-channel-set stable" ;;
          *RC*) present_terminal "leenix-channel-set rc" ;;
          *Edge*) present_terminal "leenix-channel-set edge" ;;
          *Dev*) present_terminal "leenix-channel-set dev" ;;
          *) show_update_menu ;;
          esac
        }
        show_update_process_menu() {
          case $(menu "Restart" "  Hypridle\n  Hyprsunset\n󰎟  Mako\n  Swayosd\n󰌧  Walker\n󰍜  Waybar") in
          *Hypridle*) leenix-restart-hypridle ;;
          *Hyprsunset*) leenix-restart-hyprsunset ;;
          *Mako*) leenix-restart-mako ;;
          *Swayosd*) leenix-restart-swayosd ;;
          *Walker*) leenix-restart-walker ;;
          *Waybar*) leenix-restart-waybar ;;
          *) show_update_menu ;;
          esac
        }
        
        show_update_config_menu() {
          case $(menu "Use default config" "  Hyprland\n  Hypridle\n  Hyprlock\n  Hyprsunset\n󱣴  Plymouth\n  Swayosd\n  Tmux\n󰌧  Walker\n󰍜  Waybar") in
          *Hyprland*) present_terminal leenix-refresh-hyprland ;;
          *Hypridle*) present_terminal leenix-refresh-hypridle ;;
          *Hyprlock*) present_terminal leenix-refresh-hyprlock ;;
          *Hyprsunset*) present_terminal leenix-refresh-hyprsunset ;;
          *Plymouth*) present_terminal leenix-refresh-plymouth ;;
          *Swayosd*) present_terminal leenix-restart-swayosd ;;
          *Tmux*) present_terminal leenix-refresh-tmux ;;
          *Walker*) present_terminal leenix-refresh-walker ;;
          *Waybar*) present_terminal leenix-refresh-waybar ;;
          *) show_update_menu ;;
          esac
        }
        
        show_update_hardware_menu() {
          case $(menu "Restart" "  Audio\n󱚾  Wi-Fi\n󰂯  Bluetooth\n󰟸  Trackpad") in
          *Audio*) present_terminal leenix-restart-pipewire ;;
          *Wi-Fi*) present_terminal leenix-restart-wifi ;;
          *Bluetooth*) present_terminal leenix-restart-bluetooth ;;
          *Trackpad*) present_terminal leenix-restart-trackpad ;;
          *) show_update_menu ;;
          esac
        }
        
        show_update_password_menu() {
          case $(menu "Update Password" "  Drive Encryption\n  User") in
          *Drive*) present_terminal leenix-drive-password ;;
          *User*) present_terminal passwd ;;
          *) show_update_menu ;;
          esac
        }
        
        show_about() {
          leenix-launch-about
        }
        
        show_system_menu() {
          local options="󱄄  Screensaver\n  Lock"
          ! leenix-toggle-enabled suspend-off && options="$options\n󰒲  Suspend"
          leenix-hibernation-available && options="$options\n󰤁  Hibernate"
          options="$options\n󰍃  Logout\n󰜉  Restart\n󰐥  Shutdown"
        
          case $(menu "System" "$options") in
          *Screensaver*) leenix-launch-screensaver force ;;
          *Lock*) leenix-system-lock ;;
          *Suspend*) systemctl suspend ;;
          *Hibernate*) systemctl hibernate ;;
          *Logout*) leenix-system-logout ;;
          *Restart*) leenix-system-reboot ;;
          *Shutdown*) leenix-system-shutdown ;;
          *) back_to show_main_menu ;;
          esac
        }
        
        show_main_menu() {
          go_to_menu "$(menu "Go" "󰀻  Apps\n󰧑  Learn\n󱓞  Trigger\n  Style\n  Setup\n󰉉  Install\n󰭌  Remove\n  Update\n  About\n  System")"
        }
        
        go_to_menu() {
          case "''${1,,}" in
          *apps*) walker -p "Launch…" ;;
          *learn*) show_learn_menu ;;
          *trigger*) show_trigger_menu ;;
          *toggle*) show_toggle_menu ;;
          *hardware*) show_hardware_menu ;;
          *share*) show_share_menu ;;
          *reminder-set*) show_custom_reminder_input ;;
          *reminder*) show_reminder_menu ;;
          *background*) show_background_menu ;;
          *capture*) show_capture_menu ;;
          *style*) show_style_menu ;;
          *theme*) show_theme_menu ;;
          *screenrecord*) show_screenrecord_menu ;;
          *setup*) show_setup_menu ;;
          *power*) show_setup_power_menu ;;
          *install*) show_install_menu ;;
          *remove*) show_remove_menu ;;
          *update*) show_update_menu ;;
          *about*) show_about ;;
          *system*) show_system_menu ;;
          esac
        }
        
        # Allow user extensions and overrides
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
