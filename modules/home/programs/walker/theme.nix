{ ... }:

{
  # LEENIX Walker themes.
  #
  # leenix-default  - the standard app-launcher theme (Apps, keybindings lists).
  # leenix-menu     - compact variant for LEENIX menu panels: no hardcoded
  #                   width-request, so each invocation's --width governs the
  #                   panel size. Shares the same visual identity (style.css).
  xdg.configFile."walker/themes/leenix-default/style.css".source = ./files/style.css;
  xdg.configFile."walker/themes/leenix-default/layout.xml".source = ./files/layout.xml;

  xdg.configFile."walker/themes/leenix-menu/style.css".source = ./files/style.css;
  xdg.configFile."walker/themes/leenix-menu/layout.xml".source = ./files/leenix-menu-layout.xml;
}
