let
  palette = import ../../../lib/leenium.nix;
in
{
  programs.btop = {
    enable = true;

    settings = {
      color_theme = "leenium";
      theme_background = true;
      truecolor = true;
    };

    themes.leenium = ''
      theme[main_bg]="${palette.background.main}"
      theme[main_fg]="${palette.neutral.foreground}"
      theme[title]="${palette.neutral.foreground}"
      theme[hi_fg]="${palette.accent.teal}"
      theme[selected_bg]="${palette.background.active}"
      theme[selected_fg]="${palette.neutral.bright}"
      theme[inactive_fg]="${palette.neutral.muted}"
      theme[graph_text]="${palette.accent.yellow}"
      theme[meter_bg]="${palette.neutral.border}"
      theme[proc_misc]="${palette.neutral.secondary}"
      theme[cpu_box]="${palette.accent.emerald}"
      theme[mem_box]="${palette.accent.cyan}"
      theme[net_box]="${palette.accent.blue}"
      theme[proc_box]="${palette.accent.blue}"
      theme[div_line]="${palette.neutral.border}"
      theme[temp_start]="${palette.accent.emerald}"
      theme[temp_mid]="${palette.accent.yellow}"
      theme[temp_end]="${palette.accent.red}"
      theme[cpu_start]="${palette.accent.emerald}"
      theme[cpu_mid]="${palette.accent.cyan}"
      theme[cpu_end]="${palette.neutral.foreground}"
      theme[free_start]="${palette.accent.blue}"
      theme[free_mid]="${palette.accent.blue}"
      theme[free_end]="${palette.neutral.foreground}"
      theme[cached_start]="${palette.neutral.border}"
      theme[cached_mid]="${palette.neutral.activeBorder}"
      theme[cached_end]="${palette.neutral.disabled}"
      theme[available_start]="${palette.neutral.secondary}"
      theme[available_mid]="${palette.accent.yellow}"
      theme[available_end]="${palette.accent.red}"
      theme[used_start]="${palette.accent.emerald}"
      theme[used_mid]="${palette.accent.emerald}"
      theme[used_end]="${palette.accent.cyan}"
      theme[download_start]="${palette.accent.blue}"
      theme[download_mid]="${palette.accent.blue}"
      theme[download_end]="${palette.neutral.secondary}"
      theme[upload_start]="${palette.accent.teal}"
      theme[upload_mid]="${palette.accent.cyan}"
      theme[upload_end]="${palette.accent.cyan}"
      theme[process_start]="${palette.accent.blue}"
      theme[process_mid]="${palette.neutral.secondary}"
      theme[process_end]="${palette.accent.teal}"
    '';
  };
}
