{ pkgs, leenix, ... }:

# Neovim config = static LEENIX dotfiles + a generated Mason-skip fragment.
#
# Ownership reconciliation (D1): LSPs and linters selected through LEENIX
# development policy are Nix-owned. Mason must not install them too. The
# generated nvim/lua/leenix/mason-skip.lua lists the mason package names for
# ENABLED development.lsp.* and development.linters.* leaves (mapped from the
# audited masonames table), merged into tiredconfig.mason.skip by
# dotfiles/nvim/lua/tired/mason/init.lua. Explicit ownership, no PATH heuristics,
# no broad Mason disable.
let
  dev = leenix.development;
  enabledIn = cat: leaf:
    if dev ? ${cat} && dev.${cat} ? ${leaf} then dev.${cat}.${leaf}.enable
    else false;

  # LEENIX leaf -> mason package name(s). Verified against the existing
  # tired/mason/names.lua and conform/lint configs.
  leafToMason = {
    # development.lsp.<leaf>
    gopls = [ "gopls" ];
    "lua-language-server" = [ "lua-language-server" ];
    nil = [ "nil" ];
    nixd = [ "nixd" ];
    pyright = [ "pyright" ];
    "rust-analyzer" = [ "rust-analyzer" ];
    "typescript-language-server" = [ "typescript-language-server" ];
    # development.linters.<leaf>
    black = [ "black" ];
    eslint = [ "eslint_d" ];
    nixfmt = [ "nixfmt" ];
    prettier = [ "prettier" "prettierd" ];
    ruff = [ "ruff" ];
    shellcheck = [ "shellcheck" ];
    shfmt = [ "shfmt" ];
  };

  masonSkip = builtins.concatLists (map (leaf: leafToMason.${leaf})
    (builtins.filter (leaf: enabledIn "lsp" leaf || enabledIn "linters" leaf)
      (builtins.attrNames leafToMason)));
in
{
  programs.neovim = {
    enable = true;
  };

  xdg.configFile."nvim" = {
    source = pkgs.runCommand "leenix-nvim-config" { } ''
      cp -r ${../../../dotfiles/nvim}/. "$out/"
      chmod -R u+w "$out"
      mkdir -p "$out/lua/leenix"
      cat > "$out/lua/leenix/mason-skip.lua" <<EOF
      return { skip = ${builtins.toJSON masonSkip} }
      EOF
    '';
  };
}
