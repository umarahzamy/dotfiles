local wezterm = require("wezterm")
local config = {}

-- Keep your other settings (font, shell, etc.)
config.default_prog = { "pwsh.exe" }
config.font = wezterm.font("JetBrains Mono")
config.color_scheme = "Nord (base16)"
return config
