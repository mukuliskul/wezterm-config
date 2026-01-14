local wezterm = require("wezterm")
local module = {}

-- Configuration: Directories to scan for projects and configs
local SCAN_DIRS = {
	wezterm.home_dir .. "/mpac-commercial/projects",
	wezterm.home_dir .. "/.config"
}

-- Cache for workspace directories to avoid repeated scanning
local cached_directories = nil

-- File to store last workspace
local LAST_WORKSPACE_FILE = os.getenv("HOME") .. "/.wezterm_last_workspace"

-- Helper to read last workspace from file
local function read_last_workspace()
	local file = io.open(LAST_WORKSPACE_FILE, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content:gsub("%s+", "")  -- trim whitespace
	end
	return nil
end

-- Helper to write last workspace to file
local function write_last_workspace(workspace)
	local file = io.open(LAST_WORKSPACE_FILE, "w")
	if file then
		file:write(workspace)
		file:close()
	end
end

-- Get all directories to offer as workspace options
local function get_workspace_directories()
	if cached_directories then
		return cached_directories
	end

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

	cached_directories = directories
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
		-- Record current workspace as "last" before switching
		write_last_workspace(window:active_workspace())

		local directories = get_workspace_directories()
		local choices = {}

		-- Convert directories to choice format for the picker
		for i, dir_path in ipairs(directories) do
			table.insert(choices, { label = i .. ". " .. dir_path })
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

-- Show workspace selector with numbered options
function module.show_workspace_selector()
	return wezterm.action_callback(function(window, pane)
		local workspaces = wezterm.mux.get_workspace_names()
		table.sort(workspaces)  -- alphabetical order

		if #workspaces == 0 then
			return
		end

		local choices = {}
		for i, ws_name in ipairs(workspaces) do
			table.insert(choices, {
				label = i .. ". " .. ws_name,
				id = ws_name
			})
		end

		window:perform_action(
			wezterm.action.InputSelector({
				title = "Choose Workspace",
				choices = choices,
				fuzzy = true,
				action = wezterm.action_callback(function(child_window, child_pane, id, label)
					if not id then
						return
					end
					child_window:perform_action(
						wezterm.action.SwitchToWorkspace({ name = id }),
						child_pane
					)
				end),
			}),
			pane
		)
	end)
end

-- Cycle workspaces forward
function module.cycle_workspaces_forward()
	return wezterm.action_callback(function(window, pane)
		local workspaces = wezterm.mux.get_workspace_names()
		table.sort(workspaces)  -- alphabetical order

		if #workspaces <= 1 then
			return
		end

		local current = window:active_workspace()
		local current_index = nil
		for i, ws in ipairs(workspaces) do
			if ws == current then
				current_index = i
				break
			end
		end

		if not current_index then return end  -- shouldn't happen

		local next_index = current_index % #workspaces + 1
		local next_workspace = workspaces[next_index]

		window:perform_action(
			wezterm.action.SwitchToWorkspace({ name = next_workspace }),
			pane
		)
	end)
end

-- Cycle workspaces backward
function module.cycle_workspaces_backward()
	return wezterm.action_callback(function(window, pane)
		local workspaces = wezterm.mux.get_workspace_names()
		table.sort(workspaces)  -- alphabetical order

		if #workspaces <= 1 then
			return
		end

		local current = window:active_workspace()
		local current_index = nil
		for i, ws in ipairs(workspaces) do
			if ws == current then
				current_index = i
				break
			end
		end

		if not current_index then return end

		local prev_index = (current_index - 2) % #workspaces + 1
		local prev_workspace = workspaces[prev_index]

		window:perform_action(
			wezterm.action.SwitchToWorkspace({ name = prev_workspace }),
			pane
		)
	end)
end

return module
