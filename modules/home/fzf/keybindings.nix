{
  programs.fzf = {
    enableZshIntegration = true;

    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";

    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";

    historyWidgetOptions = [
      "--sort"
      "--exact"
    ];
  };
}
