{ ... }:

{
  home.file.".config/hypr/bindings.conf" = {
    force = true;

    text = ''
      # Application bindings

      bindd = SUPER, RETURN, Terminal, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)"
      bindd = SUPER SHIFT, RETURN, Tmux, exec, uwsm-app -- xdg-terminal-exec --dir="$(omarchy-cmd-terminal-cwd)" bash -c "tmux attach || tmux new -s Work"
      bindd = SUPER SHIFT, F, File manager, exec, uwsm-app -- nautilus --new-window
      bindd = SUPER ALT SHIFT, F, File manager (cwd), exec, uwsm-app -- nautilus --new-window "$(omarchy-cmd-terminal-cwd)"
      bindd = SUPER, B, Browser, exec, omarchy-launch-browser
      bindd = SUPER SHIFT, B, Browser (private), exec, omarchy-launch-browser --private
      bindd = SUPER, M, Music, exec, omarchy-launch-or-focus spotify
      bindd = SUPER ALT, M, Music TUI, exec, omarchy-launch-or-focus-tui cliamp
      bindd = SUPER SHIFT, N, Editor, exec, omarchy-launch-editor
      bindd = SUPER SHIFT, D, Docker, exec, omarchy-launch-tui lazydocker
      bindd = SUPER SHIFT, S, Signal, exec, omarchy-launch-or-focus ^signal$ "uwsm-app -- signal-desktop"
      bindd = SUPER, SLASH, Bitwarden, exec, uwsm-app -- bitwarden

      # If your web app url contains #, type it as ## to prevent hyprland treating it as a comment

      bindd = SUPER SHIFT, A, ChatGPT, exec, omarchy-launch-webapp "https://chatgpt.com"
      bindd = SUPER SHIFT, E, Email, exec, omarchy-launch-webapp "https://mail.google.com"
      bindd = SUPER SHIFT, Y, YouTube, exec, omarchy-launch-webapp "https://youtube.com/"
      bindd = SUPER SHIFT, X, X, exec, omarchy-launch-webapp "https://x.com/"
      bindd = SUPER SHIFT ALT, X, X Post, exec, omarchy-launch-webapp "https://x.com/compose/post"

      # Zoom Bindings
      bindd = SUPER, Z, Zoom, exec, ~/.local/bin/hypr-zoom toggle
      bind = SUPER, EQUAL, exec, ~/.local/bin/hypr-zoom in
      bind = SUPER, KP_ADD, exec, ~/.local/bin/hypr-zoom in
      bind = SUPER, MINUS, exec, ~/.local/bin/hypr-zoom out
      bind = SUPER, KP_SUBTRACT, exec, ~/.local/bin/hypr-zoom out

      # Add extra bindings

      # bind = SUPER SHIFT, R, exec, alacritty -e ssh your-server

      # Overwrite existing bindings, like putting Omarchy Menu on Super + Space

      # unbind = SUPER, SPACE

      # bindd = SUPER, SPACE, Omarchy menu, exec, omarchy-menu

      # Logitech MX Keys

      # bind = SUPER SHIFT, S, exec, omarchy-capture-screenshot      # Print Screen Button

      # bind = SUPER, H, exec, voxtype record toggle                 # Dictation Button

      # bind = SUPER, PERIOD, exec, omarchy-launch-walker -m symbols # Emoji Button
    '';
  };
}
