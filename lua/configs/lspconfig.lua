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

	-- Go to next diagnostic
	vim.keymap.set("n", "<leader>R", vim.diagnostic.goto_next, { buffer = bufnr })

	-- Show code actions
	vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, { buffer = bufnr })

	-- Copy the error message at the cursor position
	vim.keymap.set("n", "<leader>E", function()
		local diagnostics = vim.diagnostic.get()
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		for _, diagnostic in ipairs(diagnostics) do
			if diagnostic.lnum == cursor_pos[1] - 1 then
				-- Copy the diagnostic message to the clipboard
				vim.fn.setreg("+", diagnostic.message)
				print("Copied to clipboard: " .. diagnostic.message)
				break
			end
		end
	end, { buffer = bufnr })
end
local on_init = configs.on_init
local capabilities = configs.capabilities

local lspconfig = require("lspconfig")
local servers = { "html", "cssls", "clangd", "ts_ls", "tailwindcss" }

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

lspconfig.gdscript.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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

-- vim.api.nvim_create_autocmd("BufWritePost", {
-- 	pattern = "*.dart",
-- 	callback = function()
-- 		vim.cmd("FlutterReanalyze")
-- 	end,
-- })
