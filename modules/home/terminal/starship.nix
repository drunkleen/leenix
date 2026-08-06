let
  palette = import ../../../lib/leenium.nix;
in
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
        style_user = "bold ${palette.accent.cyan}";
        style_root = "bold ${palette.accent.red}";
      };

      hostname = {
        ssh_only = true;
        format = "on [$hostname](bold ${palette.accent.blue}) ";
      };

      directory = {
        format = "in [$path]($style) ";
        style = "bold ${palette.accent.cyan}";
        truncation_length = 3;
        truncate_to_repo = true;
        home_symbol = "~";
        read_only = " ";
      };

      git_branch = {
        symbol = " ";
        format = "on [$symbol$branch]($style) ";
        style = "bold ${palette.accent.teal}";
      };

      git_status = {
        format = "[$all_status$ahead_behind]($style) ";
        style = "bold ${palette.accent.yellow}";
      };

      nix_shell = {
        symbol = " ";
        format = "via [$symbol$name]($style) ";
        style = "bold ${palette.accent.blue}";
      };

      cmd_duration = {
        min_time = 2000;
        format = "took [$duration]($style) ";
        style = "bold ${palette.accent.yellow}";
      };

      character = {
        success_symbol = "[❯](bold ${palette.accent.emerald})";
        error_symbol = "[❯](bold ${palette.accent.red})";
        vimcmd_symbol = "[❮](bold ${palette.accent.emerald})";
      };
    };
  };
}
