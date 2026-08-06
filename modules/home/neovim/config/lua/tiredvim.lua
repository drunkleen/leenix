-- tired.nvim config follows the local UI schema.

---@type TiredConfig
local M = {}

M.base46 = {
  theme = "leenium",
}

M.tireddash = {
  load_on_startup = true,
  header = {
      "                                                ",
      " ▄▄▄    ▄▄▄             ▄▄▄▄  ▄▄▄▄              ",
      " ████▄  ███             ▀███  ███▀ ▀▀           ",
      " ███▀██▄███ ▄█▀█▄ ▄███▄  ███  ███  ██  ███▄███▄ ",
      " ███  ▀████ ██▄█▀ ██ ██  ███▄▄███  ██  ██ ██ ██ ",
      " ███    ███ ▀█▄▄▄ ▀███▀   ▀████▀   ██▄ ██ ██ ██ ",
      "                                                ",
      "                            Powered By  eovim ",
      "                                                ",
  },
  buttons = {
    { txt = "  Find File", keys = "ff", cmd = "Telescope find_files" },
    { txt = "  Recent Files", keys = "fo", cmd = "Telescope oldfiles" },
    { txt = "󰈭  Find Word", keys = "fw", cmd = "Telescope live_grep" },
    { txt = "  Mappings", keys = "ch", cmd = "TiredCheatsheet" },
    { txt = "", hl = "TiredDashFooter", no_gap = true, rep = true },
    {
      txt = "  Nix-managed plugins",
      hl = "TiredDashFooter",
      no_gap = true,
      content = "fit",
    },
    { txt = "", hl = "TiredDashFooter", no_gap = true, rep = true },
  },
}

return M
