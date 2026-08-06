local function setup(name, options)
  require(name).setup(options)
end

setup("nvim-web-devicons", { override = require "tired.icons.devicons" })

local ibl = require "ibl"
ibl.setup {
  indent = { char = "│", highlight = "IblChar" },
  scope = { char = "│", highlight = "IblScopeChar" },
}

local mini = require "mini.indentscope"
mini.setup { symbol = "│" }

setup("nvim-tree", require "tired.configs.nvimtree")
setup("which-key", {})
vim.notify = require "notify"
setup("noice", {
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
})
setup("conform", require "tired.configs.conform")
require "tired.configs.lint"
setup("gitsigns", require "tired.configs.gitsigns")
require("tired.configs.lspconfig").defaults()

require("luasnip").config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
}
require "tired.configs.luasnip"
setup("nvim-autopairs", {})
setup("cmp", require "tired.configs.cmp")
setup("telescope", require "tired.configs.telescope")
setup("nvim-treesitter", require "tired.configs.treesitter")
