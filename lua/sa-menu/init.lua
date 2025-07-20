local M = {}

local function get_plugin_root()
	local path = debug.getinfo(1, "S").source:sub(2)
	path = vim.fn.fnamemodify(path, ":p:h:h:h")
	return path
end

local function play_sound(sound_name)
	local plugin_root = get_plugin_root()
	local sound_path = plugin_root .. "/samps/" .. sound_name .. ".wav"

	if vim.fn.filereadable(sound_path) == 1 then
		vim.fn.jobstart({ "play", sound_path }, {
			detach = true,
			-- on_stderr = function(_, data)
			--   if data and #data > 0 then
			--     vim.notify("Error playing sound: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
			--   end
			-- end
		})
	end
end

function M.setup(opts)
	opts = opts or {}

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

