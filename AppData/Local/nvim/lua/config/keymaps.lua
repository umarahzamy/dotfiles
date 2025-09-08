vim.keymap.set("n", "<leader>fT", function()
  Snacks.terminal(nil, {
    cwd = LazyVim.root(),
    win = {
      position = "right",
      width = 0.5,
    },
  })
end, { desc = "Terminal right (Root Dir)" })

vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, {
    win = {
      position = "right",
      width = 0.5,
    },
  })
end, { desc = "Terminal right (cwd)" })

vim.keymap.set("n", "<C-/>", function()
  Snacks.terminal(nil, {
    win = {
      position = "right",
      width = 0.5,
    },
  })
end, { desc = "Terminal right (cwd)" })

vim.keymap.set("n", "<C-_>", function()
  Snacks.terminal(nil, {
    win = {
      position = "right",
      width = 0.5,
    },
  })
end, { desc = "which_key_ignored_right" })
