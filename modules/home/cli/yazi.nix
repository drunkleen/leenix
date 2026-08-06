let
  leenium = import ../../../lib/leenium.nix;
in
{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    theme = {
      app.overall = {
        bg = leenium.neutral.background;
      };

      mgr = {
        cwd = {
          fg = leenium.accent.teal;
          bold = true;
        };
        find_keyword = {
          fg = leenium.accent.yellow;
          bold = true;
        };
        find_position = {
          fg = leenium.neutral.muted;
        };
        symlink_target = {
          fg = leenium.accent.cyan;
        };
        marker_copied = {
          fg = leenium.accent.blue;
          bg = leenium.background.selection;
        };
        marker_cut = {
          fg = leenium.accent.red;
          bg = leenium.background.selection;
        };
        marker_marked = {
          fg = leenium.accent.yellow;
          bg = leenium.background.selection;
        };
        marker_selected = {
          fg = leenium.accent.teal;
          bg = leenium.background.selection;
        };
        border_style = {
          fg = leenium.neutral.muted;
        };
      };

      indicator = {
        parent = {
          fg = leenium.neutral.disabled;
        };
        current = {
          fg = leenium.accent.teal;
        };
        preview = {
          fg = leenium.accent.cyan;
        };
      };

      tabs = {
        active = {
          fg = leenium.neutral.bright;
          bg = leenium.background.active;
          bold = true;
        };
        inactive = {
          fg = leenium.neutral.secondary;
          bg = leenium.neutral.surface;
        };
      };

      status = {
        overall = {
          fg = leenium.neutral.foreground;
          bg = leenium.neutral.surface;
        };
        progress_label = {
          fg = leenium.neutral.foreground;
          bold = true;
        };
        progress_normal = {
          fg = leenium.accent.teal;
          bg = leenium.neutral.elevated;
        };
        progress_error = {
          fg = leenium.accent.red;
          bg = leenium.neutral.elevated;
        };
      };

      input = {
        border = {
          fg = leenium.accent.teal;
        };
        title = {
          fg = leenium.accent.teal;
          bold = true;
        };
        value = {
          fg = leenium.neutral.foreground;
        };
        selected = {
          fg = leenium.neutral.bright;
          bg = leenium.background.selection;
        };
      };

      confirm = {
        border = {
          fg = leenium.accent.teal;
        };
        title = {
          fg = leenium.neutral.bright;
          bold = true;
        };
        btn_yes = {
          fg = leenium.accent.emerald;
          bold = true;
        };
        btn_no = {
          fg = leenium.accent.red;
          bold = true;
        };
      };

      which = {
        mask = {
          bg = leenium.neutral.background;
        };
        cand = {
          fg = leenium.accent.teal;
          bold = true;
        };
        desc = {
          fg = leenium.neutral.foreground;
        };
      };

      filetype.rules = [
        {
          url = "*/";
          fg = leenium.accent.cyan;
          bold = true;
        }
        {
          mime = "image/*";
          fg = leenium.accent.yellow;
        }
        {
          mime = "{audio,video}/*";
          fg = leenium.accent.orange;
        }
        {
          url = "*";
          "is" = "orphan";
          fg = leenium.accent.red;
        }
      ];
    };
  };
}
