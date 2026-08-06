local M = {}
local api = vim.api

local function set_indent(buf, opts)
  vim.bo[buf].expandtab = opts.expandtab ~= false
  vim.bo[buf].shiftwidth = opts.shiftwidth
  vim.bo[buf].tabstop = opts.tabstop or opts.shiftwidth
  vim.bo[buf].softtabstop = opts.softtabstop or opts.shiftwidth
end

-- Per-filetype defaults follow the language's normal indentation style.
local rules = {
  lua = { shiftwidth = 2 },

  html = { shiftwidth = 2 },
  htmldjango = { shiftwidth = 2 },
  jinja = { shiftwidth = 2 },
  gohtml = { shiftwidth = 2 },
  gohtmltmpl = { shiftwidth = 2 },
  twig = { shiftwidth = 2 },
  njk = { shiftwidth = 2 },
  mustache = { shiftwidth = 2 },
  handlebars = { shiftwidth = 2 },
  hbs = { shiftwidth = 2 },
  templ = { shiftwidth = 2 },
  javascript = { shiftwidth = 2 },
  javascriptreact = { shiftwidth = 2 },
  typescript = { shiftwidth = 2 },
  typescriptreact = { shiftwidth = 2 },
  css = { shiftwidth = 2 },
  json = { shiftwidth = 2 },
  jsonc = { shiftwidth = 2 },
  markdown = { shiftwidth = 2 },
  xml = { shiftwidth = 2 },
  yaml = { shiftwidth = 2 },
  yml = { shiftwidth = 2 },
  ["yaml.docker-compose"] = { shiftwidth = 2 },
  sql = { shiftwidth = 2 },

  python = { shiftwidth = 4 },
  java = { shiftwidth = 4 },
  rust = { shiftwidth = 4 },
  c = { shiftwidth = 4 },
  cpp = { shiftwidth = 4 },
  zig = { shiftwidth = 4 },
  haskell = { shiftwidth = 4 },
  dockerfile = { shiftwidth = 4 },

  go = { expandtab = false, shiftwidth = 8, tabstop = 8, softtabstop = 8 },
}

M.setup = function()
  api.nvim_create_autocmd("FileType", {
    pattern = vim.tbl_keys(rules),
    callback = function(args)
      set_indent(args.buf, rules[vim.bo[args.buf].filetype])
    end,
  })
end

return M
