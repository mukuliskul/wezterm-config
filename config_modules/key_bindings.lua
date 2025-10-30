local wezterm = require("wezterm")
local projects = require("config_modules.projects")

return {
	leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 },
	keys = {
		{
			mods = "LEADER",
			key = "x",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},
		{
			mods = "LEADER",
			key = "m",
			action = wezterm.action.TogglePaneZoomState,
		},
		{
			key = ",",
			mods = "LEADER",
			action = wezterm.action.PromptInputLine({
				description = "Enter new name for tab",
				action = wezterm.action_callback(function(window, pane, line)
					if line then
						window:active_tab():set_title(line)
					end
				end),
			}),
		},
		{
			mods = "LEADER",
			key = "p",
			action = projects.choose_project(),
		},
		{
			mods = "LEADER",
			key = "f",
			action = wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
		},
		{
			mods = "LEADER",
			key = "|",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			mods = "LEADER",
			key = "-",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			mods = "LEADER",
			key = "[",
			action = wezterm.action.ActivateCopyMode,
		},
	},
}
