-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- For example, changing the color scheme:
config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font("JetBrains Mono NL", {
	weight = "Regular",
	style = "Normal",
})
config.font_size = 16

config.window_decorations = "RESIZE"

-- tmux
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
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
		mods = "LEADER",
		key = "p",
		action = wezterm.action.ActivateTabRelative(-1),
	},
	{
		mods = "LEADER",
		key = "n",
		action = wezterm.action.ActivateTabRelative(1),
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
		mods = "LEADER",
		key = "L",
		action = wezterm.action.EmitEvent("do-my-layout"),
	},
}

-- tab bar
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false

-- tmux status
wezterm.on("update-right-status", function(window, _)
	local SOLID_LEFT_ARROW = ""
	local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
	local prefix = ""

	if window:leader_is_active() then
		prefix = " " .. utf8.char(0x1f30a) -- ocean wave
		SOLID_LEFT_ARROW = utf8.char(0xe0b2)
	end

	if window:active_tab():tab_id() ~= 0 then
		ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
	end -- arrow color based on if tab is first pane

	window:set_left_status(wezterm.format({
		{ Background = { Color = "#b7bdf8" } },
		{ Text = prefix },
		ARROW_FOREGROUND,
		{ Text = SOLID_LEFT_ARROW },
	}))
end)

-- smart-splits
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
smart_splits.apply_to_config(config)

wezterm.on("do-my-layout", function(window, pane)
	-- `window, pane` here refer to the window/pane where the key was pressed
	-- but we want to spawn a new window layout maybe. You can use mux.spawn_window.

	local cwd = wezterm.home_dir -- adjust if needed

	-- spawn new window and main tab/pane
	local tab, main_pane, new_window = mux.spawn_window({ cwd = cwd })

	-- top/main: cd local-dev then awslogin
	main_pane:send_text("cd local-dev\n")
	main_pane:send_text("awslogin\n")
	main_pane:send_text("nvim\n")

	-- split down
	local bottom_pane = main_pane:split({
		direction = "Bottom",
		size = 0.5,
		cwd = cwd,
	})
	bottom_pane:send_text("cd local-dev\n")
	bottom_pane:send_text("dcdpu\n")

	-- split bottom pane to right
	local bottom_right = bottom_pane:split({
		direction = "Right",
		size = 0.5,
		cwd = cwd,
	})
	bottom_right:send_text("cd cosmos\n")
	bottom_right:send_text("./start_test_container.sh\n")

	-- new tab at end
	local new_tab, tab_pane, _ = new_window:spawn_tab({ cwd = cwd })
	tab_pane:send_text("cd cosmos\n")
	tab_pane:send_text("nvim\n")

	-- maximize
	-- new_window:gui_window():maximize()
end)

-- This will run when wezterm starts up
wezterm.on("gui-startup", function(cmd)
	wezterm.emit("do-my-layout", nil, nil)
end)

-- and finally, return the configuration to wezterm
return config
