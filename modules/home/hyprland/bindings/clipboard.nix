{ lib, ... }:

let
  binds = [
    {
      keys = "SUPER + C";
      description = "Universal copy";
      action = ''
        hl.dsp.send_shortcut({
          mods = "CTRL",
          key = "Insert",
          window = "activewindow"
        })
      '';
    }

    {
      keys = "SUPER + V";
      description = "Universal paste";
      action = ''
        hl.dsp.send_shortcut({
          mods = "SHIFT",
          key = "Insert",
          window = "activewindow"
        })
      '';
    }

    {
      keys = "SUPER + X";
      description = "Universal cut";
      action = ''
        hl.dsp.send_shortcut({
          mods = "CTRL",
          key = "X",
          window = "activewindow"
        })
      '';
    }

    {
      keys = "SUPER + CTRL + V";
      description = "Clipboard manager";
      action = ''
        hl.dsp.exec_cmd("leenix-launch-walker -m clipboard")
      '';
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
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${bindLines}
  '';
}
