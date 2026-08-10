{ lib, ... }:

let
  describedBinds = [
    {
      keys = "SUPER + RETURN";
      description = "Terminal";
      command = ''uwsm-app -- xdg-terminal-exec --dir="$(leenix-cmd-terminal-cwd)"'';
    }
    {
      keys = "SUPER + SHIFT + RETURN";
      description = "Tmux";
      command = ''uwsm-app -- xdg-terminal-exec --dir="$(leenix-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"'';
    }
    {
      keys = "SUPER + E";
      description = "File manager";
      command = "leenix-launch-file-manager";
    }
    {
      keys = "SUPER + B";
      description = "Browser";
      command = "leenix-launch-browser";
    }
    {
      keys = "SUPER + SHIFT + B";
      description = "Browser (private)";
      command = "leenix-launch-browser --private";
    }
    {
      keys = "SUPER + M";
      description = "Music";
      command = "leenix-launch-or-focus spotify";
    }
    {
      keys = "SUPER + ALT + M";
      description = "Music TUI";
      command = "leenix-launch-or-focus-tui cliamp";
    }
    {
      keys = "SUPER + SHIFT + N";
      description = "Editor";
      command = "leenix-launch-editor";
    }
    {
      keys = "SUPER + SHIFT + D";
      description = "Docker";
      command = "leenix-launch-tui lazydocker";
    }
    {
      keys = "SUPER + SHIFT + S";
      description = "Signal";
      command = ''leenix-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"'';
    }
    {
      keys = "SUPER + SLASH";
      description = "Bitwarden";
      command = "uwsm-app -- bitwarden";
    }

    {
      keys = "SUPER + SHIFT + A";
      description = "ChatGPT";
      command = ''leenix-launch-webapp "https://chatgpt.com"'';
    }
    {
      keys = "SUPER + SHIFT + E";
      description = "Email";
      command = ''leenix-launch-webapp "https://mail.google.com"'';
    }
    {
      keys = "SUPER + SHIFT + Y";
      description = "YouTube";
      command = ''leenix-launch-webapp "https://youtube.com/"'';
    }
    {
      keys = "SUPER + SHIFT + X";
      description = "X";
      command = ''leenix-launch-webapp "https://x.com/"'';
    }
    {
      keys = "SUPER + SHIFT + ALT + X";
      description = "X Post";
      command = ''leenix-launch-webapp "https://x.com/compose/post"'';
    }

    {
      keys = "SUPER + Z";
      description = "Zoom";
      command = "~/.local/bin/hypr-zoom toggle";
    }
  ];

  binds = [
    {
      keys = "SUPER + EQUAL";
      command = "leenix-hypr-zoom in";
    }
    {
      keys = "SUPER + KP_ADD";
      command = "leenix-hypr-zoom in";
    }
    {
      keys = "SUPER + MINUS";
      command = "leenix-hypr-zoom out";
    }
    {
      keys = "SUPER + KP_SUBTRACT";
      command = "leenix-hypr-zoom out";
    }
  ];

  describedBindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command}),
          { description = ${builtins.toJSON bind.description} }
        )
      '')
      describedBinds;

  bindLines =
    lib.concatMapStringsSep "\n"
      (bind: ''
        hl.bind(
          ${builtins.toJSON bind.keys},
          hl.dsp.exec_cmd(${builtins.toJSON bind.command})
        )
      '')
      binds;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    ${describedBindLines}

    ${bindLines}

    hl.unbind("SUPER + SLASH")
  '';
}
