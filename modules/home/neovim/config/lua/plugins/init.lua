return {

  -- cursor animarion
  {
    "sphamba/smear-cursor.nvim",
    event = "VeryLazy",
    opts = {
      -- Smooth out cursor motion without changing buffer behavior.
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = false,
      smear_insert_mode = true,
    },
  },

  -- smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = true,
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb" },
    },
    config = function(_, opts)
      require("neoscroll").setup(opts)
    end,
  },

  -- time tracking
  {
    "wakatime/vim-wakatime",
    event = "VeryLazy",
  },
}
