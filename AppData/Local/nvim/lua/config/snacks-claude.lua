---@class Snacks
---@field claude snacks.claude

---@class snacks.claude
---@overload fun(opts?: snacks.claude.Config): snacks.win
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

M.meta = {
  desc = "Open Claude Code in a float",
}

---@class snacks.claude.Config: snacks.terminal.Opts
local defaults = {
  win = {
    style = "claude",
  },
}

-- Register the claude style
Snacks.config.style("claude", {})

-- Opens Claude Code
---@param opts? snacks.terminal.Opts
function M.open(opts)
  opts = Snacks.config.get("claude", defaults, opts)

  local cmd = { "claude" }

  return Snacks.terminal(cmd, opts)
end

-- Add to global Snacks table
local function setup()
  if not Snacks then
    return
  end
  Snacks.claude = M
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
