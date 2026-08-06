local api = vim.api
local config = require "tiredconfig"
local new_cmd = api.nvim_create_user_command

if config.ui.statusline.enabled then
  vim.o.statusline = "%!v:lua.require('tired.stl." .. config.ui.statusline.theme .. "')()"
  require("tired.stl.utils").autocmds()
end

if config.ui.tabufline.enabled then
  require "tired.tabufline.lazyload"
end

-- Command to toggle tired dash
new_cmd("TiredDash", function()
  if vim.g.tireddash_displayed then
    require("tired.tabufline").close_buffer(vim.g.tireddash_buf)
  else
    require("tired.tireddash").open()
  end
end, {})

new_cmd("TiredCheatsheet", function()
  if vim.g.nvcheatsheet_displayed then
    vim.cmd "bw"
  else
    require("tired.cheatsheet." .. config.cheatsheet.theme)()
  end
end, {})

vim.schedule(function()
  require "tired.au"
end)
