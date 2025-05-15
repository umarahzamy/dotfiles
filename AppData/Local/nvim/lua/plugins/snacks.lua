return {
  "folke/snacks.nvim",
  opts = {
    terminal = {
      start_insert = false,
      auto_insert = false,
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
        },
      },
    },
  },
}
