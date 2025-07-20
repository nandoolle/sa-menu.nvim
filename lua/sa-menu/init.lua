local M = {}

local sound_queue = {}
local is_playing = false
local last_sound_time = {}
local debounce_time = 150

local function get_plugin_root()
	local path = debug.getinfo(1, "S").source:sub(2)
	path = vim.fn.fnamemodify(path, ":p:h:h:h")
	return path
end

local function get_sound_command()
	local os_name = vim.loop.os_uname().sysname
	if os_name == "Darwin" then
		return { "afplay" }
	elseif os_name == "Linux" then
		if vim.fn.executable("aplay") == 1 then
			return { "aplay", "-q" }
		elseif vim.fn.executable("paplay") == 1 then
			return { "paplay" }
		elseif vim.fn.executable("play") == 1 then
			return { "play", "-q" }
		end
	else
		return { "play" }
	end
	return nil
end

local function process_queue()
	if #sound_queue == 0 then
		is_playing = false
		return
	end

	is_playing = true
	local sound_path = table.remove(sound_queue, 1)
	local cmd = get_sound_command()
	
	if cmd then
		local full_cmd = vim.list_extend(vim.deepcopy(cmd), { sound_path })
		vim.fn.jobstart(full_cmd, {
			detach = false,
			on_exit = function()
				vim.defer_fn(process_queue, 10)
			end,
		})
	else
		is_playing = false
	end
end

local function play_sound(sound_name)
	local current_time = vim.loop.now()
	local last_time = last_sound_time[sound_name] or 0
	
	if current_time - last_time < debounce_time then
		return
	end
	
	last_sound_time[sound_name] = current_time
	
	local plugin_root = get_plugin_root()
	local sound_path = plugin_root .. "/samps/" .. sound_name .. ".wav"

	if vim.fn.filereadable(sound_path) == 1 then
		if #sound_queue < 3 then
			table.insert(sound_queue, sound_path)
			if not is_playing then
				process_queue()
			end
		end
	end
end

function M.setup(opts)
	opts = opts or {}
	
	if opts.debounce_time then
		debounce_time = opts.debounce_time
	end
	
	if opts.enabled == false then
		return
	end

	vim.api.nvim_create_autocmd("ModeChanged", {
		pattern = "*",
		callback = function()
			local mode = vim.fn.mode()

			if mode == "n" then
				play_sound("normal")
			elseif mode == "i" then
				play_sound("insert")
			elseif mode == "v" or mode == "V" or mode == "\22" then
				play_sound("visual")
			elseif mode == "c" then
				play_sound("command")
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		pattern = "*",
		callback = function()
			play_sound("switch-buffer")
		end,
	})
end

return M

