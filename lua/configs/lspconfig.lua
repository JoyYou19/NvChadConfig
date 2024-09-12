local configs = require("nvchad.configs.lspconfig")

-- Define the function globally
function _G.show_diagnostics_in_vsplit()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics > 0 then
		vim.cmd("vsplit")
		local bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_win_set_buf(0, bufnr)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(diagnostics[1].message, "\n"))
	end
end

local on_attach = function(client, bufnr)
	configs.on_attach(client, bufnr)

	vim.keymap.set("n", "<leader>R", vim.diagnostic.goto_next)

	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
end
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls", "clangd", "tsserver", "tailwindcss" }

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		on_init = on_init,
		on_attach = on_attach,
		capabilities = capabilities,
	})
end

lspconfig.zls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"zls",
		"--enable-debug-log",
	},
})

lspconfig.rust_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "rust" },
	settings = {
		["rust_analyzer"] = {
			cargo = {
				allFeatures = true,
			},
			checkOnSave = {
				allFeatures = true,
				command = "clippy",
			},
			procMacro = {
				ignored = {
					["async-trait"] = { "async_trait" },
					["napi-derive"] = { "napi" },
					["async-recursion"] = { "async_recursion" },
				},
			},
		},
	},
})

lspconfig.wgsl_analyzer.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "wgsl" },
})

lspconfig.gopls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "go" },
})

-- vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.format()]])
--
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	pattern = "*.wgsl",
	callback = function()
		vim.bo.filetype = "wgsl"
	end,
})
