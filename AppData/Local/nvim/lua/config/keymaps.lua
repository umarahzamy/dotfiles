-- Check if directory exists
local function has_dir(path)
  return vim.fn.isdirectory(path) == 1
end

-- Check if executable is available
local function has_executable(cmd)
  return vim.fn.executable(cmd) == 1
end

pcall(function()
  require("config.snacks-claude")
  require("config.snacks-gitui")
  require("config.snacks-psql")
end)

-- Window option presets
local WinOpts = {
  right = function()
    return { position = "right", width = 0.5 }
  end,
  float = function(title)
    return {
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      title = " " .. title .. " ",
      title_pos = "center",
    }
  end,
}

-- Terminal right (Root Dir)
vim.keymap.set("n", "<leader>fT", function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = WinOpts.right() })
end, { desc = "Terminal right (Root Dir)" })

-- Terminal right (cwd)
vim.keymap.set("n", "<leader>ft", function()
  Snacks.terminal(nil, { win = WinOpts.right() })
end, { desc = "Terminal right (cwd)" })

vim.keymap.set("n", "<C-/>", function()
  Snacks.terminal(nil, { win = WinOpts.right() })
end, { desc = "Terminal right (cwd)" })

vim.keymap.set("n", "<C-_>", function()
  Snacks.terminal(nil, { win = WinOpts.right() })
end, { desc = "which_key_ignored_right" })

-- Backlog.md
if has_executable("backlog") then
  vim.keymap.set("n", "<leader>B", function()
    local backlog_path = LazyVim.root() .. "/backlog"
    if not has_dir(backlog_path) then
      vim.notify("backlog.md not initialized in project root", vim.log.levels.ERROR)
      return
    end
    Snacks.terminal(nil, { cwd = LazyVim.root(), win = WinOpts.float("Backlog.md") })
  end, { desc = "Backlog.md" })
end

-- Claude code
if has_executable("claude") then
  vim.keymap.set("n", "<leader>C", function()
    Snacks.claude({
      cwd = LazyVim.root(),
      win = WinOpts.float("Claude Code"),
    })
  end, { desc = "Claude Code" })
end

-- GitUI
if has_executable("gitui") then
  vim.keymap.set("n", "<leader>gg", function()
    Snacks.gitui({ cwd = LazyVim.root(), win = WinOpts.float("GitUI") })
  end, { desc = "GitUI (Root Dir)" })
end

-- PostgreSQL (psql)
if has_executable("psql") then
  vim.keymap.set("n", "<leader>D", function()
    Snacks.psql({ cwd = LazyVim.root(), win = WinOpts.float("PostgreSQL") })
  end, { desc = "PostgreSQL (psql)" })
end
