{
  programs.zsh.initContent = ''
    bindkey -e

    # Home / End
    bindkey "^[[H" beginning-of-line
    bindkey "^[[F" end-of-line
    bindkey "^[[1~" beginning-of-line
    bindkey "^[[4~" end-of-line
    bindkey "^[[7~" beginning-of-line
    bindkey "^[[8~" end-of-line

    # Delete
    bindkey "^[[3~" delete-char

    # Ctrl + Left / Right
    bindkey "^[[1;5D" backward-word
    bindkey "^[[1;5C" forward-word
    bindkey "^[[5D" backward-word
    bindkey "^[[5C" forward-word

    # Alt + Left / Right
    bindkey "^[b" backward-word
    bindkey "^[f" forward-word

    # Ctrl + Backspace
    bindkey "^H" backward-kill-word
    bindkey "^?" backward-delete-char

    # Ctrl + Delete
    bindkey "^[[3;5~" kill-word

    # Useful editing shortcuts
    bindkey "^A" beginning-of-line
    bindkey "^E" end-of-line
    bindkey "^U" backward-kill-line
    bindkey "^K" kill-line
    bindkey "^W" backward-kill-word
    bindkey "^L" clear-screen
  '';
}
