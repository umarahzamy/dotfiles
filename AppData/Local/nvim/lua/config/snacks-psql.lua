---@class Snacks
---@field psql snacks.psql

---@class snacks.psql
---@overload fun(opts?: snacks.psql.Config): snacks.win
local M = setmetatable({}, {
  __call = function(t, ...)
    return t.open(...)
  end,
})

M.meta = {
  desc = "Open PostgreSQL (psql) in a float",
}

---@class snacks.psql.Config: snacks.terminal.Opts
local defaults = {
  win = {
    style = "psql",
  },
}

-- Register the psql style
Snacks.config.style("psql", {})

-- Parse .env into key-value pairs
local function parse_env_file(path)
  if vim.fn.filereadable(path) ~= 1 then
    return nil
  end
  local env_vars = {}
  for _, line in ipairs(vim.fn.readfile(path)) do
    if not line:match("^%s*#") and not line:match("^%s*$") then
      local key, value = line:match("^%s*([A-Z_]+)%s*=%s*[\"']?(.-)[\"']?%s*$")
      if key and value then
        env_vars[key] = value
      end
    end
  end
  return env_vars
end

-- Opens PSQL with environment variables from .env file
---@param opts? snacks.terminal.Opts
function M.open(opts)
  opts = Snacks.config.get("psql", defaults, opts)

  -- Check if psql is available
  if vim.fn.executable("psql") ~= 1 then
    vim.notify("psql not found", vim.log.levels.ERROR)
    return nil
  end

  -- Parse .env file and set up environment variables
  local env_path = require("lazyvim.util").root() .. "./.env"
  local env_vars = parse_env_file(env_path)
  if not env_vars then
    vim.notify("no .env file found", vim.log.levels.ERROR)
    return nil
  end

  -- Check required environment variables
  local required_vars = { "PGHOST", "PGPORT", "PGDATABASE", "PGUSER" }
  local missing = {}
  for _, var in ipairs(required_vars) do
    if not env_vars[var] or env_vars[var] == "" then
      table.insert(missing, var)
    end
  end

  if #missing > 0 then
    vim.notify("incomplete .env configuration: " .. table.concat(missing, ", "), vim.log.levels.ERROR)
    return nil
  end

  -- Set environment variables
  opts.env = env_vars

  local cmd = { "psql" }

  return Snacks.terminal(cmd, opts)
end

-- Add to global Snacks table
local function setup()
  if not Snacks then
    return
  end
  Snacks.psql = M
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
