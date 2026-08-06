vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- load theme
require("base46").load_all_highlights()
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "tired.setup"

require "tired"

require "options"
require "autocmds"

vim.schedule(function()
  require "mappings"
end)
