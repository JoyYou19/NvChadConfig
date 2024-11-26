local M = {

	filetype = {
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		dart = {
			require("formatter.filetypes.dart").dart,
		},

		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		typescriptreact = { -- Add this to handle .tsx files
			require("formatter.filetypes.typescript").prettier,
		},

		html = {

			require("formatter.filetypes.html").prettier,
		},

		lua = {
			require("formatter.filetypes.lua").stylua,
		},

		css = {
			require("formatter.filetypes.css").prettier,
		},
		go = {
			-- Add gofmt formatter for Go files
			function()
				return {
					exe = "gofmt",
					args = {}, -- No additional arguments needed for gofmt
					stdin = true,
				}
			end,
		},

		rust = {
			-- Add rustfmt formatter for rust files
			function()
				return {
					exe = "rustfmt",
					args = { "--edition", "2021" }, -- Specify the Rust edition if needed
					stdin = true,
				}
			end,
		},
		["*"] = {
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	-- Use conditional autocmd to avoid formatting Rust on save
	callback = function()
		if vim.bo.filetype ~= "rust" then
			vim.cmd("FormatWriteLock")
		end
	end,
})

-- Key mapping to format Rust and other files on demand
vim.api.nvim_set_keymap("n", "<leader>F", ":lua require('formatter').format()<CR>", { noremap = true, silent = true })
return M
