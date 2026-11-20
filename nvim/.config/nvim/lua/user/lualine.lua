local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    print("Failed to load plugin lualine")
	return
end

local hide_in_width = function()
	return vim.fn.winwidth(0) > 80
end

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn" },
	symbols = { error = " ", warn = " " },
	colored = false,
	update_in_insert = false,
	always_visible = true,
}

local diff = {
	"diff",
	colored = false,
	symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  cond = hide_in_width
}

local mode = {
	"mode",
	fmt = function(str)
		return "-- " .. str .. " --"
	end,
}

local filetype = {
	"filetype",
	icons_enabled = false,
	icon = nil,
}

local branch = {
	"branch",
	icons_enabled = true,
	icon = "",
}

local location = {
	"location",
	padding = 0,
}

-- cool function for progress
local progress = function()
	local current_line = vim.fn.line(".")
	local total_lines = vim.fn.line("$")
	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
	local line_ratio = current_line / total_lines
	local index = math.ceil(line_ratio * #chars)
	return chars[index]
end

local spaces = function()
	return "spaces: " .. vim.bo.shiftwidth
end

-- LSP $/progress (e.g. rust-analyzer indexing). Empty when nothing is running.
-- Not vim.lsp.status(): it drains the progress queue on each call, and lualine
-- renders many times per event. Its output also has a bare "%", which is an
-- invalid statusline item.
local progress_tasks = {} -- "client:token" -> { text, seq }
local progress_seq = 0

local lsp_progress = function()
	local latest
	for _, task in pairs(progress_tasks) do
		if not latest or task.seq > latest.seq then
			latest = task
		end
	end
	return latest and latest.text or ""
end

vim.api.nvim_create_autocmd("LspProgress", {
	group = vim.api.nvim_create_augroup("user.lualine.lsp_progress", {}),
	callback = function(ev)
		local params = ev.data and ev.data.params
		local value = params and params.value
		if type(value) ~= "table" then
			return
		end
		local key = ev.data.client_id .. ":" .. tostring(params.token)
		if value.kind == "end" then
			progress_tasks[key] = nil
		else
			local prev = progress_tasks[key]
			local title = value.title or (prev and prev.title) or ""
			local text = value.message and (title .. ": " .. value.message) or title
			if value.percentage then
				text = value.percentage .. "% " .. text
			end
			progress_seq = progress_seq + 1
			progress_tasks[key] = { title = title, text = (text:gsub("%%", "%%%%")), seq = progress_seq }
		end
		lualine.refresh()
	end,
})

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
		always_divide_middle = true,
	},
	sections = {
		lualine_a = { branch, diagnostics },
		lualine_b = { mode },
		lualine_c = { lsp_progress },
		-- lualine_x = { "encoding", "fileformat", "filetype" },
		lualine_x = { diff, spaces, "encoding", filetype },
		lualine_y = { location },
		lualine_z = { progress },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {},
	extensions = {},
})
