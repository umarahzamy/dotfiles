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

vim.keymap.set("n", "<leader>gg", function()
  -- check if .git directory exists in project root
  local function has_git_dir()
    local git_path = LazyVim.root() .. "/.git"
    return vim.fn.isdirectory(git_path) == 1
  end

  if not has_git_dir() then
    vim.notify("not a git repository", vim.log.levels.ERROR)
    return
  end

  Snacks.terminal("clear && gitui", {
    cwd = LazyVim.root(),
    win = {
      style = "float",
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      title = " GitUI ",
      title_pos = "center",
    },
  })
end, { desc = "GitUI (Root Dir)" })

vim.keymap.set("n", "<leader>D", function()
  -- parse .env file
  local function parse_env_file()
    local env_path = LazyVim.root() .. "/.env"
    local env_vars = {}

    local file = io.open(env_path, "r")
    if not file then
      return nil
    end

    for line in file:lines() do
      -- Skip comments and empty lines
      if line:match("^%s*#") or line:match("^%s*$") then
        goto continue
      end

      -- Parse KEY=VALUE format
      local key, value = line:match("^%s*([A-Z_]+)%s*=%s*[\"']?(.-)[\"']?%s*$")
      if key and value then
        env_vars[key] = value
      end

      ::continue::
    end

    file:close()
    return env_vars
  end

  -- build psql command from .env
  local env_vars = parse_env_file()
  local psql_cmd = nil

  if not env_vars then
    vim.notify("no .env file found", vim.log.levels.ERROR)
    return
  end

  -- check required postgresql variables
  local required_vars = { "PGHOST", "PGPORT", "PGDATABASE", "PGUSERNAME" }
  local missing_vars = {}

  for _, var in ipairs(required_vars) do
    if not env_vars[var] or env_vars[var] == "" then
      table.insert(missing_vars, var)
    end
  end

  if #missing_vars > 0 then
    vim.notify("incomplete .env configuration", vim.log.levels.ERROR)
    return
  end

  -- build psql command
  local args = {}
  table.insert(args, "-h " .. env_vars.PGHOST)
  table.insert(args, "-p " .. env_vars.PGPORT)
  table.insert(args, "-d " .. env_vars.PGDATABASE)
  table.insert(args, "-U " .. env_vars.PGUSERNAME)

  psql_cmd = "psql " .. table.concat(args, " ")

  Snacks.terminal("clear;" .. psql_cmd, {
    cwd = LazyVim.root(),
    win = {
      style = "float",
      position = "float",
      width = 0.9,
      height = 0.9,
      border = "rounded",
      title = " PostgreSQL ",
      title_pos = "center",
    },
  })
end, { desc = "PostgreSQL (psql)" })
