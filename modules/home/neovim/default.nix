{ pkgs, ... }:

let
  leenium = import ../../../lib/leenium.nix;

  leeniumTheme = pkgs.writeText "tired-leenium.lua" ''
    local M = {}

    M.base_30 = {
      white = "${leenium.neutral.foreground}",
      darker_black = "${leenium.neutral.baseBlack}",
      black = "${leenium.neutral.background}",
      black2 = "${leenium.neutral.surface}",
      one_bg = "${leenium.neutral.surface}",
      one_bg2 = "${leenium.neutral.elevated}",
      one_bg3 = "${leenium.neutral.border}",
      grey = "${leenium.background.selection}",
      grey_fg = "${leenium.neutral.muted}",
      grey_fg2 = "${leenium.neutral.secondary}",
      light_grey = "${leenium.neutral.secondary}",
      red = "${leenium.accent.red}",
      baby_pink = "${leenium.accent.red}",
      pink = "${leenium.accent.red}",
      line = "${leenium.neutral.border}",
      green = "${leenium.accent.emerald}",
      vibrant_green = "${leenium.accent.emerald}",
      nord_blue = "${leenium.accent.blue}",
      blue = "${leenium.accent.blue}",
      yellow = "${leenium.accent.yellow}",
      sun = "${leenium.accent.yellow}",
      purple = "${leenium.accent.blue}",
      dark_purple = "${leenium.accent.blue}",
      teal = "${leenium.accent.teal}",
      orange = "${leenium.accent.orange}",
      cyan = "${leenium.accent.cyan}",
      statusline_bg = "${leenium.neutral.surface}",
      lightbg = "${leenium.neutral.elevated}",
      pmenu_bg = "${leenium.accent.teal}",
      folder_bg = "${leenium.accent.teal}",
    }

    M.base_16 = {
      base00 = "${leenium.neutral.background}",
      base01 = "${leenium.neutral.surface}",
      base02 = "${leenium.background.selection}",
      base03 = "${leenium.neutral.muted}",
      base04 = "${leenium.neutral.secondary}",
      base05 = "${leenium.neutral.foreground}",
      base06 = "${leenium.neutral.bright}",
      base07 = "${leenium.neutral.bright}",
      base08 = "${leenium.accent.red}",
      base09 = "${leenium.accent.orange}",
      base0A = "${leenium.accent.yellow}",
      base0B = "${leenium.accent.emerald}",
      base0C = "${leenium.accent.cyan}",
      base0D = "${leenium.accent.blue}",
      base0E = "${leenium.accent.teal}",
      base0F = "${leenium.accent.red}",
    }

    M.type = "dark"
    M = require("base46").override_theme(M, "leenium")

    return M
  '';

  tiredConfig = pkgs.runCommand "tired-nvim-config" { } ''
    cp -r ${./config}/. "$out"
    chmod -R u+w "$out"
    install -Dm444 ${leeniumTheme} "$out/lua/base46/themes/leenium.lua"
  '';
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      fd
      git
      lua-language-server
      luaPackages.luacheck
      ripgrep
      rust-analyzer
      rustfmt
      wl-clipboard

      clang-tools
      cpplint
      djlint
      docker-compose-language-service
      dockerfile-language-server
      eslint_d
      fourmolu
      gofumpt
      golangci-lint
      google-java-format
      gopls
      hadolint
      haskell-language-server
      htmlhint
      htmx-lsp
      isort
      jdt-language-server
      jinja-lsp
      lemminx
      markdownlint-cli
      marksman
      prettier
      prettierd
      pyright
      python3
      ruff
      sqlfluff
      sqls
      stylelint
      stylua
      templ
      typescript-language-server
      vscode-langservers-extracted
      xmlformat
      yaml-language-server
      yamlfmt
      yamllint
      zls
    ];

    plugins = with pkgs.vimPlugins; [
      luasnip
      cmp-async-path
      cmp-buffer
      cmp-nvim-lsp
      cmp-nvim-lua
      cmp_luasnip
      conform-nvim
      friendly-snippets
      gitsigns-nvim
      indent-blankline-nvim
      mini-indentscope
      noice-nvim
      nui-nvim
      nvim-autopairs
      nvim-cmp
      nvim-lint
      nvim-lspconfig
      nvim-notify
      nvim-tree-lua
      nvim-treesitter
      (nvim-treesitter.withPlugins (
        parsers: with parsers; [
          c
          cpp
          css
          dockerfile
          go
          gotmpl
          haskell
          html
          htmldjango
          java
          javascript
          jinja
          jinja_inline
          json
          lua
          luadoc
          markdown
          markdown_inline
          printf
          rust
          sql
          templ
          tsx
          twig
          typescript
          vim
          vimdoc
          xml
          yaml
          zig
        ]
      ))
      nvim-web-devicons
      plenary-nvim
      telescope-nvim
      which-key-nvim
    ];
  };

  xdg.configFile."nvim" = {
    source = tiredConfig;
    recursive = true;
  };
}
