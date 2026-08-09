{ ... }:

{
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir=\"$(leenix-cmd-terminal-cwd)\""
      "SUPER SHIFT, RETURN, Tmux, exec, uwsm-app -- xdg-terminal-exec --dir=\"$(leenix-cmd-terminal-cwd)\" bash -c \"tmux attach || tmux new -s Work\""
      "SUPER, E, File manager, exec, uwsm-app -- nautilus --new-window"
      "SUPER, B, Browser, exec, leenix-launch-browser"
      "SUPER SHIFT, B, Browser (private), exec, leenix-launch-browser --private"
      "SUPER, M, Music, exec, leenix-launch-or-focus spotify"
      "SUPER ALT, M, Music TUI, exec, leenix-launch-or-focus-tui cliamp"
      "SUPER SHIFT, N, Editor, exec, leenix-launch-editor"
      "SUPER SHIFT, D, Docker, exec, leenix-launch-tui lazydocker"
      "SUPER SHIFT, S, Signal, exec, leenix-launch-or-focus ^signal$ \"uwsm-app -- signal-desktop\""
      "SUPER, SLASH, Bitwarden, exec, uwsm-app -- bitwarden"

      "SUPER SHIFT, A, ChatGPT, exec, leenix-launch-webapp \"https://chatgpt.com\""
      "SUPER SHIFT, E, Email, exec, leenix-launch-webapp \"https://mail.google.com\""
      "SUPER SHIFT, Y, YouTube, exec, leenix-launch-webapp \"https://youtube.com/\""
      "SUPER SHIFT, X, X, exec, leenix-launch-webapp \"https://x.com/\""
      "SUPER SHIFT ALT, X, X Post, exec, leenix-launch-webapp \"https://x.com/compose/post\""

      "SUPER, Z, Zoom, exec, ~/.local/bin/hypr-zoom toggle"
    ];

    bind = [
      "SUPER, EQUAL, exec, ~/.local/bin/hypr-zoom in"
      "SUPER, KP_ADD, exec, ~/.local/bin/hypr-zoom in"
      "SUPER, MINUS, exec, ~/.local/bin/hypr-zoom out"
      "SUPER, KP_SUBTRACT, exec, ~/.local/bin/hypr-zoom out"
    ];

    unbind = [
      "SUPER, SLASH"
    ];
  };
}
