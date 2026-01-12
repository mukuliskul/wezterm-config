local wezterm = require("wezterm")
local module = {}

-- Configuration: Directories to scan for projects and configs
local SCAN_DIRS = {
	wezterm.home_dir .. "/mpac-commercial/projects",
	wezterm.home_dir .. "/.config"
}

-- Get all directories to offer as workspace options
local function get_workspace_directories()
	local directories = {}

	-- Always include home directory
	table.insert(directories, wezterm.home_dir)

	-- Scan all configured directories for subdirectories
	for _, base_dir in ipairs(SCAN_DIRS) do
		local pattern = base_dir .. "/*"
		for _, dir in ipairs(wezterm.glob(pattern)) do
			table.insert(directories, dir)
		end
	end

	return directories
end

-- Create workspace name from directory path
local function get_workspace_name(dir_path)
	-- Use the last component of the path as workspace name
	return dir_path:match("([^/]+)$")
end

-- Main directory selection function
function module.choose_project()
	return wezterm.action_callback(function(window, pane)
		local directories = get_workspace_directories()
		local choices = {}

		-- Convert directories to choice format for the picker
		for _, dir_path in ipairs(directories) do
			table.insert(choices, { label = dir_path })
		end

		-- Show the directory picker with fuzzy search
		window:perform_action(
			wezterm.action.InputSelector({
				title = "Choose Directory",
				choices = choices,
				fuzzy = true,
				action = wezterm.action_callback(function(child_window, child_pane, id, label)
					-- Skip if nothing was selected
					if not label then
						return
					end

					-- Switch to workspace for selected directory
					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({
							name = get_workspace_name(label),
							spawn = { cwd = label },
						}),
						child_pane
					)
				end),
			}),
			pane
		)
	end)
end

return module