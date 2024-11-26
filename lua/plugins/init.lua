return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("configs.conform")
		end,
	},
	{
		"tpope/vim-dispatch",
	},
	-- {
	-- 	"nvim-flutter/flutter-tools.nvim",
	-- 	lazy = false,
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"stevearc/dressing.nvim", -- optional for vim.ui.select
	-- 	},
	-- 	config = function()
	-- 		local on_attach = function(client, bufnr)
	-- 			-- Go to next diagnostic
	-- 			vim.keymap.set("n", "<leader>R", vim.diagnostic.goto_next, { buffer = bufnr })
	--
	-- 			-- Show code actions
	-- 			vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })
	--
	-- 			-- Copy the error message at the cursor position
	-- 			vim.keymap.set("n", "<leader>E", function()
	-- 				local diagnostics = vim.diagnostic.get()
	-- 				local cursor_pos = vim.api.nvim_win_get_cursor(0)
	-- 				for _, diagnostic in ipairs(diagnostics) do
	-- 					if diagnostic.lnum == cursor_pos[1] - 1 then
	-- 						-- Copy the diagnostic message to the clipboard
	-- 						vim.fn.setreg("+", diagnostic.message)
	-- 						print("Copied to clipboard: " .. diagnostic.message)
	-- 						break
	-- 					end
	-- 				end
	-- 			end, { buffer = bufnr })
	-- 		end
	--
	-- 		require("flutter-tools").setup({
	-- 			lsp = {
	-- 				on_attach = on_attach, -- Attach your custom `on_attach`
	-- 				color = {
	-- 					enabled = true,
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	"nvim-lua/plenary.nvim",

	{
		"habamax/vim-godot",
		event = "VimEnter",
	},

	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},

	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"zadirion/Unreal.nvim",
		lazy = false,
		-- config = function()
		-- 	require("tpope/vim-dispatch")
		-- end,
	},
	-- Load custom plugin: code_tracker
	{
		dir = "C:/Users/valte/AppData/Local/nvim/lua/code_tracker", -- Specify the directory where your plugin is stored
		lazy = false,
		config = function()
			require("code_tracker").setup() -- Call the setup function from your plugin
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			ensure_installed = {
				"css-lsp",
				"lua-language-server",
				"prettier",
				"rust-analyzer",
				"stylua",
				"zls",
				"typescript-language-server",
				"html-lsp",
				"eslint-lsp",
				"eslin_d",
				"htmlhint",
			},
		},
	},

	{
		"mhartington/formatter.nvim",
		event = "VeryLazy",
		opts = function()
			return require("configs.formatter")
		end,
	},

	{
		"nvim-tree/nvim-tree.lua",
		opts = {
			git = { enable = true },

			actions = {
				open_file = {
					quit_on_open = true,
				},
			},
		},
	},
	{
		"ziglang/zig.vim",
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() vim.cmd('normal! zz') end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
	},
	-- In order to modify the `lspconfig` configuration:
	{
		"simrat39/rust-tools.nvim",
		lazy = false,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},
	{ "elentok/format-on-save.nvim" },
	{
		"saecki/crates.nvim",
		ft = { "rust", "toml" },
		config = function(_, opts)
			local crates = require("crates")
			crates.setup(opts)
			crates.show()
		end,
	},
	{
		-- Completion framework:
		"hrsh7th/nvim-cmp",

		-- LSP completion source:
		"hrsh7th/cmp-nvim-lsp",

		-- Useful completion sources:
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/vim-vsnip",
	},
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		opts = {
			ensure_installed = {
				"gdscript",
				"godot_resource",
				"gdshader",
				"c",
				"cpp",
				"prisma",
				"rust",
				"toml",
				"wgsl",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = { enable = true },
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		},
	},
	{
		"mfussenegger/nvim-lint",
		event = {
			"BufReadPre",
			"BufNewFile",
		},
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte = { "eslint_d" },
				kotlin = { "ktlint" },
				terraform = { "tflint" },
				ruby = { "standardrb" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})

			vim.keymap.set("n", "<leader>ll", function()
				lint.try_lint()
			end, { desc = "Trigger linting for current file" })
		end,
	},
}
