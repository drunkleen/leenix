local autocmd = vim.api.nvim_create_autocmd

-- Detect common template and compose filenames up front so LSP/formatters attach correctly.
vim.filetype.add {
  filename = {
    ["docker-compose.yml"] = "yaml.docker-compose",
    ["docker-compose.yaml"] = "yaml.docker-compose",
    ["compose.yml"] = "yaml.docker-compose",
    ["compose.yaml"] = "yaml.docker-compose",
  },

  pattern = {
    [".*/templates/.+%.html$"] = "htmldjango",
    [".*/templates/.+%.htm$"] = "htmldjango",
    [".*%.html%.j2$"] = "jinja",
    [".*%.jinja2?$"] = "jinja",
    [".*%.djhtml$"] = "htmldjango",
    [".*%.html%.django$"] = "htmldjango",
    [".*%.gohtml$"] = "gohtml",
    [".*%.gohtmltmpl$"] = "gohtmltmpl",
    [".*%.gotmpl$"] = "gohtmltmpl",
    [".*%.tmpl$"] = "gohtmltmpl",
    [".*%.html%.tmpl$"] = "gohtmltmpl",
    [".*%.tmpl%.html$"] = "gohtmltmpl",
    [".*%.twig$"] = "twig",
    [".*%.njk$"] = "njk",
    [".*%.mustache$"] = "mustache",
    [".*%.hbs$"] = "handlebars",
    [".*%.handlebars$"] = "handlebars",
    [".*%.templ$"] = "templ",
  },
}

vim.treesitter.language.register("yaml", "yaml.docker-compose")

-- Go template files are split across a few common names in the wild.
vim.treesitter.language.register("gotmpl", "gohtml")
vim.treesitter.language.register("gotmpl", "gohtmltmpl")
vim.treesitter.language.register("twig", "twig")
vim.treesitter.language.register("htmldjango", "htmldjango")
vim.treesitter.language.register("jinja", "jinja")
vim.treesitter.language.register("templ", "templ")

-- Keep indent defaults close to the language's normal style.
require("tired.indent").setup()

-- user event that loads after UIEnter + only if file buf is there
autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("NvFilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name "NvFilePost"

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

local create_cmd = vim.api.nvim_create_user_command

create_cmd("TSInstallAll", function()
  local spec = require("lazy.core.config").plugins["nvim-treesitter"]
  local opts = type(spec.opts) == "table" and spec.opts or {}
  require("nvim-treesitter").install(opts.ensure_installed)
end, {})
