{
  config,
  lib,
  pkgs,
  vars,
  ...
}:

let
  palette = import ../../../lib/leenium.nix;

  scripts = import ../../../scripts/default.nix {
    inherit pkgs;
    touchpadDevice = vars.hardware.touchpad.device;
  };
in
{
  services.swayosd.enable = true;

  systemd.user.services.swayosd = {
    Unit = {
      After = lib.mkForce [ config.leenix.fallbackSession.target ];
      PartOf = lib.mkForce [ config.leenix.fallbackSession.target ];
    };
    Install.WantedBy = lib.mkForce [ config.leenix.fallbackSession.target ];
  };

  xdg.configFile."swayosd/style.css".text = ''
    @define-color background-color ${palette.background.panel};
    @define-color border-color ${palette.neutral.border};
    @define-color foreground ${palette.neutral.foreground};
    @define-color progress-start ${palette.accent.teal};
    @define-color progress-end ${palette.accent.cyan};

    window {
      background: transparent;
      border: none;
      box-shadow: none;
      padding: 12px;
    }

    #container {
      min-width: 280px;
      padding: 12px 16px;

      background-color: alpha(@background-color, 0.95);
      border: 2px solid alpha(@border-color, 0.92);
      border-radius: 0;
      box-shadow: none;
    }

    image,
    label {
      color: @foreground;
    }

    progressbar {
      min-height: 8px;
    }

    progressbar trough {
      min-height: 8px;
      background-color: alpha(@border-color, 0.45);
      border: none;
      border-radius: 0;
      box-shadow: none;
    }

    progressbar progress {
      min-height: 8px;

      background-image: linear-gradient(
        90deg,
        @progress-start,
        @progress-end
      );

      border: none;
      border-radius: 0;
      box-shadow: none;
    }
  '';

  home.packages = with pkgs; [
    swayosd
    brightnessctl
    playerctl
    scripts.toggleTouchpad
  ];
}
