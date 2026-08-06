{ pkgs, vars, ... }:

let
  scripts = import ../../../scripts/default.nix {
    inherit pkgs;
    touchpadDevice = vars.hardware.touchpad.device;
  };
in
{
  services.swayosd.enable = true;

  xdg.configFile."swayosd/style.css".text = ''
    @define-color background-color #11191c;
    @define-color border-color #223033;
    @define-color foreground #d8e3e0;
    @define-color progress-start #33b8a8;
    @define-color progress-end #59d6c5;

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
