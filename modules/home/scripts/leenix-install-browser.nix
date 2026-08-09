{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-install-browser";

      runtimeInputs = with pkgs; [
        coreutils
      ];

      text = ''
        #!/bin/bash
        LEENIX_PATH=''${LEENIX_PATH:-$HOME/.local/share/leenix}

        # leenix:summary=Install a supported browser

        # leenix:args=<chrome|brave|brave-origin|edge|firefox|zen>

        # leenix:examples=leenix install browser firefox | leenix install browser brave

        setup_policy_directory() {
          sudo mkdir -p "$1"
          sudo chmod a+rw "$1"
        }

        announce_browser_installed() {
          echo ""
          echo "$1 browser installed. Make it the default via Setup > Defaults > Browser."
        }

        copy_chromium_flags() {
          mkdir -p ~/.config
          cp -f "''${LEENIX_PATH:-$HOME/.local/share/leenix}/config/chromium-flags.conf" "$1"
        }

        setup_firefox_preferences() {
          local distribution_dir="$1"

          setup_policy_directory "$distribution_dir"
          sudo cp -f "''${LEENIX_PATH:-$HOME/.local/share/leenix}/default/firefox/policies.json" "$distribution_dir/policies.json"
        }

        setup_firefox_wayland() {
          mkdir -p ~/.config/environment.d
          echo "MOZ_ENABLE_WAYLAND=1" > ~/.config/environment.d/leenix-firefox-wayland.conf
        }

        case ''${1:-} in
          chrome)
            echo "Installing Chrome..."
            leenix-pkg-aur-add google-chrome || exit 1

            setup_policy_directory /etc/opt/chrome/policies/managed
            copy_chromium_flags ~/.config/chrome-flags.conf
            leenix-theme-set-browser
            announce_browser_installed "Chrome"
            ;;
          edge)
            echo "Installing Edge..."
            leenix-pkg-aur-add microsoft-edge-stable-bin || exit 1

            setup_policy_directory /etc/opt/edge/policies/managed
            copy_chromium_flags ~/.config/microsoft-edge-stable-flags.conf
            leenix-theme-set-browser
            announce_browser_installed "Edge"
            ;;
          brave)
            echo "Installing Brave..."
            leenix-pkg-aur-add brave-bin || exit 1

            setup_policy_directory /etc/brave/policies/managed
            copy_chromium_flags ~/.config/brave-flags.conf
            leenix-theme-set-browser
            announce_browser_installed "Brave"
            ;;
          brave-origin)
            echo "Installing Brave Origin..."
            leenix-pkg-aur-add brave-origin-beta-bin || exit 1

            setup_policy_directory /etc/brave/policies/managed
            mkdir -p ~/.config

            # FIXME: Use normal chromium flags when Brave Origin wrapper has been fixed

            echo "--load-extension=~/.local/share/leenix/default/chromium/extensions/copy-url" > ~/.config/brave-origin-beta-flags.conf
            leenix-theme-set-browser
            announce_browser_installed "Brave Origin"
            ;;
          firefox)
            echo "Installing Firefox..."
            leenix-pkg-add firefox || exit 1

            setup_firefox_preferences /usr/lib/firefox/distribution
            setup_firefox_wayland
            announce_browser_installed "Firefox"
            ;;
          zen)
            echo "Installing Zen..."
            leenix-pkg-aur-add zen-browser-bin || exit 1

            setup_firefox_preferences /opt/zen-browser/distribution
            setup_firefox_wayland
            announce_browser_installed "Zen"
            ;;
          *)
            echo "Usage: leenix-install-browser <chrome|brave|brave-origin|edge|firefox|zen>"
            exit 1
            ;;
        esac
      '';
    })
  ];
}