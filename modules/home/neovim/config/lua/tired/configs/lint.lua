local lint = require "lint"

lint.linters_by_ft = {
  lua = { "luacheck" },
  c = { "cpplint" },
  cpp = { "cpplint" },

  go = { "golangcilint" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  html = { "htmlhint" },
  htmx = { "htmlhint" },
  htmldjango = { "djlint" },
  jinja = { "djlint" },
  gohtml = { "djlint" },
  gohtmltmpl = { "djlint" },
  twig = { "djlint" },
  njk = { "djlint" },
  mustache = { "djlint" },
  handlebars = { "djlint" },
  hbs = { "djlint" },
  css = { "stylelint" },
  json = { "json_tool" },
  jsonc = { "json_tool" },
  markdown = { "markdownlint" },
  python = { "ruff" },
  sql = { "sqlfluff" },
  yaml = { "yamllint" },
  yml = { "yamllint" },
  ["yaml.docker-compose"] = { "yamllint" },
  dockerfile = { "hadolint" },
}

local group = vim.api.nvim_create_augroup("TiredLint", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWritePost", "InsertLeave" }, {
  group = group,
  callback = function()
    vim.schedule(function()
      lint.try_lint()
    end)
  end,
})

return lint
