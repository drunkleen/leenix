{
  programs.tealdeer = {
    enable = true;
    enableAutoUpdates = false;

    settings.style = {
      command_name.foreground = "cyan";
      description.foreground = "white";
      example_code.foreground = "blue";
      example_text.foreground = "green";
      example_variable = {
        foreground = "cyan";
        underline = true;
      };
      header = {
        foreground = "yellow";
        bold = true;
      };
    };
  };
}
