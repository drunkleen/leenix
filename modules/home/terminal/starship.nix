{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      command_timeout = 1000;

      format = builtins.concatStringsSep "" [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      username = {
        show_always = false;
        format = "[$user]($style) ";
        style_user = "bold cyan";
        style_root = "bold red";
      };

      hostname = {
        ssh_only = true;
        format = "on [$hostname](bold blue) ";
      };

      directory = {
        format = "in [$path]($style) ";
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
        home_symbol = "~";
        read_only = " ";
      };

      git_branch = {
        symbol = " ";
        format = "on [$symbol$branch]($style) ";
        style = "bold purple";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold yellow";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$name]($style) ";
        style = "bold blue";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bold yellow";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
    };
  };
}
