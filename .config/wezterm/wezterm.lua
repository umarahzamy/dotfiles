local wezterm = require("wezterm")
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

wezterm.on("gui-attached", function()
	-- maximize all displayed windows on startup
	local workspace = mux.get_active_workspace()
	for _, window in ipairs(mux.all_windows()) do
		if window:get_workspace() == workspace then
			window:gui_window():maximize()
		end
	end
end)

wezterm.on("format-tab-title", function(tab)
	local title = tab.active_pane.title or "Unnamed"
	return {
		{ Text = " " .. title .. " " },
	}
end)

config.animation_fps = 25
config.colors = {
	tab_bar = {
		background = "#2e2e2e",
		active_tab = {
			bg_color = "#1e1e2e",
			fg_color = "#f6f6f7",
		},
		inactive_tab = {
			bg_color = "#2e2e2e",
			fg_color = "#f6f6f7",
		},
		inactive_tab_hover = {
			bg_color = "#24242d",
			fg_color = "#f6f6f7",
		},
		new_tab = {
			bg_color = "#2e2e2e",
			fg_color = "#f6f6f7",
		},
		new_tab_hover = {
			bg_color = "#24242d",
			fg_color = "#f6f6f7",
		},
	},
}
config.color_scheme = "Catppuccin Mocha"
config.default_prog = { "pwsh.exe" }
config.font = wezterm.font("JetBrains Mono")
config.font_size = 10.0
config.front_end = "Software"
config.integrated_title_buttons = { "Hide", "Maximize", "Close" }
config.keys = {
	{
		mods = "CTRL",
		key = "t",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	{
		mods = "CTRL",
		key = "w",
		action = act.CloseCurrentTab({ confirm = false }),
	},
	{
		mods = "CTRL | ALT",
		key = "b",
		action = act.MoveTabRelative(-1),
	},
	{
		mods = "CTRL | ALT",
		key = "f",
		action = act.MoveTabRelative(1),
	},
	{
		mods = "CTRL | SHIFT",
		key = "h",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL | SHIFT",
		key = "v",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		mods = "CTRL | ALT",
		key = "h",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		mods = "CTRL | ALT",
		key = "j",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		mods = "CTRL | ALT",
		key = "k",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		mods = "CTRL | ALT",
		key = "l",
		action = act.ActivatePaneDirection("Right"),
	},
}
config.line_height = 1.2
config.max_fps = 60
config.use_fancy_tab_bar = false
config.window_background_opacity = 0.8
config.window_close_confirmation = "AlwaysPrompt"
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

return config
