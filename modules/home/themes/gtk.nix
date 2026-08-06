{ pkgs, ... }:

let
  leenium = import ../../../lib/leenium.nix;

  paletteCss = ''
    @define-color accent_bg_color ${leenium.accent.teal};
    @define-color accent_fg_color ${leenium.neutral.baseBlack};
    @define-color accent_color ${leenium.accent.teal};
    @define-color window_bg_color ${leenium.neutral.background};
    @define-color window_fg_color ${leenium.neutral.foreground};
    @define-color view_bg_color ${leenium.neutral.background};
    @define-color view_fg_color ${leenium.neutral.foreground};
    @define-color headerbar_bg_color ${leenium.neutral.surface};
    @define-color headerbar_fg_color ${leenium.neutral.foreground};
    @define-color card_bg_color ${leenium.neutral.elevated};
    @define-color card_fg_color ${leenium.neutral.foreground};
    @define-color popover_bg_color ${leenium.neutral.elevated};
    @define-color popover_fg_color ${leenium.neutral.foreground};
    @define-color dialog_bg_color ${leenium.neutral.surface};
    @define-color dialog_fg_color ${leenium.neutral.foreground};
    @define-color borders ${leenium.neutral.border};
    @define-color theme_fg_color ${leenium.neutral.foreground};
    @define-color theme_bg_color ${leenium.neutral.background};
    @define-color theme_base_color ${leenium.neutral.background};
    @define-color theme_text_color ${leenium.neutral.foreground};
    @define-color theme_selected_bg_color ${leenium.background.selection};
    @define-color theme_selected_fg_color ${leenium.neutral.bright};
  '';
in
{
  gtk = {
    enable = true;
    colorScheme = "dark";

    font = {
      name = "Noto Sans";
      size = 11;
      package = pkgs.noto-fonts;
    };

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
      gtk-enable-animations = true;
    };

    gtk3.extraCss = paletteCss;

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
      gtk-decoration-layout = "menu:";
      gtk-enable-animations = true;
    };

    gtk4.extraCss = paletteCss;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
  };
}
