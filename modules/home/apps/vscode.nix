{
  xdg.configFile."Code/User/settings.json" = {
    force = true;
    text = builtins.toJSON {
      "workbench.colorTheme" = "Leenium";
      "workbench.iconTheme" = "material-icon-theme";
    };
  };
}
