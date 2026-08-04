{
  programs.fzf = {
    defaultOptions = [
      "--height=80%"
      "--layout=reverse"
      "--border"
      "--info=inline"
      "--prompt=❯ "
      "--pointer=❯"
      "--marker=✓"
      "--preview-window=right:60%:wrap"
    ];

    fileWidgetOptions = [
      "--preview"
      "bat --color=always --style=numbers --line-range=:500 {}"
    ];

    changeDirWidgetOptions = [
      "--preview"
      "eza --tree --icons=auto --color=always {} | head -200"
    ];

    historyWidgetOptions = [
      "--preview"
      "echo {}"
    ];
  };
}
