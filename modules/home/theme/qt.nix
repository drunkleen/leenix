{
  lib,
  pkgs,
  themeMode,
  ...
}:

let
  inherit (lib) mkDefault;

  dark = themeMode == "dark";

  schemeName = if dark then "BreezeDark" else "BreezeLight";

  schemeFile = "${pkgs.kdePackages.breeze}/share/color-schemes/${schemeName}.colors";
in
{
  qt = {
    enable = mkDefault true;

    platformTheme = {
      name = "kde";
      package = [ pkgs.kdePackages.plasma-integration ];
    };

    style = {
      name = "breeze";
      package = [ pkgs.kdePackages.breeze ];
    };
  };

  # Global KDE color scheme consumed by KDE apps (e.g. Dolphin) through
  # KColorSchemeManager. The [General] TerminalApplication section is read by
  # KTerminalLauncherJob (Dolphin "Open Terminal Here") to select the LEENIX
  # terminal without depending on a Konsole service.
  xdg.configFile."kdeglobals".text = ''
    ${builtins.readFile schemeFile}

    [General]
    TerminalApplication=kitty
  '';
}
