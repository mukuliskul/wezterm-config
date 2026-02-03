local wezterm = require("wezterm")
local workspace_switcher = require("config_modules.workspace_switcher")

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
				key = "l",
				action = workspace_switcher.choose_project(),
			},
			{
				mods = "LEADER",
				key = "f",
				action = workspace_switcher.show_workspace_selector(),
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
				mods = "LEADER",
				key = "j",
				action = workspace_switcher.cycle_workspaces_forward(),
			},
			{
				mods = "LEADER",
				key = "k",
				action = workspace_switcher.cycle_workspaces_backward(),
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
		},
	}
