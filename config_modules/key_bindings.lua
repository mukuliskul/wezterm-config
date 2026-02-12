local wezterm = require("wezterm")
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")

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
		{
			key = "h",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Left"),
		},
		{
			key = "j",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "CTRL",
			action = wezterm.action.ActivatePaneDirection("Right"),
		},
		-- Resize panes with Ctrl+Shift + Arrow (5-cell steps)
		{
			key = "LeftArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.AdjustPaneSize{"Left", 5},
		},
		{
			key = "RightArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.AdjustPaneSize{"Right", 5},
		},
		{
			key = "UpArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.AdjustPaneSize{"Up", 5},
		},
		{
			key = "DownArrow",
			mods = "CTRL|SHIFT",
			action = wezterm.action.AdjustPaneSize{"Down", 5},
		},
		{
			key = "l",
			mods = "LEADER",
			action = workspace_switcher.switch_workspace(),
		},
		{
			key = "j",
			mods = "LEADER",
			action = workspace_switcher.switch_to_prev_workspace(),
		},
	},
}
