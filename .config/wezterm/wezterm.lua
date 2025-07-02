local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on("gui-attached", function(domain)
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

config.animation_fps = 60
config.color_scheme = "Catppuccin Mocha"
config.default_prog = { "pwsh.exe" }
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.0
config.leader = { key = "q", mods = "ALT", timeout_miliseconds = 2000 }
config.keys = {
    {
        mods = "CTRL",
        key = "t",
        action = wezterm.action.SpawnTab "CurrentPaneDomain",
    },	{
		key = "w",
		mods = "CTRL",
		action = act.CloseCurrentTab({ confirm = true }),
	},
}
config.line_height = 1.2
config.max_fps =  60
config.window_background_opacity = 0.5
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}
config.win32_system_backdrop = "Acrylic"

return config
