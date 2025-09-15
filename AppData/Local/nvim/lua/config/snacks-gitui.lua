---@class Snacks
---@field gitui snacks.gitui

---@class snacks.gitui
---@overload fun(opts?: snacks.gitui.Config): snacks.win
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

M.meta = {
  desc = "Open GitUI in a float",
}

---@class snacks.gitui.Config: snacks.terminal.Opts
local defaults = {
  win = {
    style = "gitui",
  },
}

-- Register the gitui style
Snacks.config.style("gitui", {})

-- Opens GitUI
---@param opts? snacks.terminal.Opts
function M.open(opts)
  opts = Snacks.config.get("gitui", defaults, opts)

  -- Check if we're in a git repository
  local dot_git_path = require("lazyvim.util").root() .. "/.git"
  if vim.fn.isdirectory(dot_git_path) ~= 1 then
    vim.notify("not a git repository", vim.log.levels.ERROR)
    return nil
  end

  local cmd = { "gitui" }

  return Snacks.terminal(cmd, opts)
end

-- Add to global Snacks table
local function setup()
  if not Snacks then
    return
  end
  Snacks.gitui = M
end

if Snacks then
  setup()
else
  vim.api.nvim_create_autocmd("User", {
    pattern = "SnacksLoaded",
    callback = setup,
  })
end

return M
