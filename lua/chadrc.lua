local M = {}

M.base46 = {
	theme = "nightfox",
	transparency = true,
}

M.ui = {

	telescope = { style = "borderless" }, -- borderless / bordered

	statusline = {
		theme = "vscode_colored", -- default/vscode/vscode_colored/minimal
		-- default/round/block/arrow separators work only for default statusline theme
		-- round and block will work for minimal theme only
		separator_style = "default",
		order = nil,
		modules = nil,
	},

	tabufline = {
		enabled = true,
		lazyload = true,
		order = { "treeOffset", "buffers", "tabs", "btns" },
		modules = nil,
	},
}

return M
