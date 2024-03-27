local options = {
  lsp_fallback = true,  -- fallback to built-in language server for unsupported types

  -- formatters for specific filetypes
  formatters_by_ft = {
    ["typescript"] = { "eslint" },  -- use eslint formatting for typescript files
    ["javascript"] = { "eslint" }, -- use eslint formatting for javascript files
    ["html"] = { "html" },          -- use built-in html formatter
    ["css"] = { "stylua" },           -- use stylua formatter for css files
  },

  -- set lspconfig server configurations (optional)
  -- this assumes you have already installed the necessary language servers
  -- for typescript (e.g., `typescriptlangserver-neurips`) and tailwind css
  lspconfig = {
    -- server configuration for typescript (adjust based on your installed server)
    tsserver = {
      additional_capabilities = {
        textdocument_formatting = true, -- enable formatting for typescript files
      },
      settings = {
        format = {
          insertspaces = false, -- use tabs instead of spaces (adjust based on preference)
          tabsize = 2,         -- set tab size to 2 spaces
        },
      },
    },

    -- server configuration for tailwind css (adjust based on your installed server)
    tailwindcss = {
      -- add configuration options for the tailwind css language server here
      -- (refer to the server's documentation for available options)
    },
  },
}



require("conform").setup(options)



vim.cmd [[
  augroup FormatAutogroup
    autocmd!
    autocmd BufWritePost *.js,*.rs,*.lua,*.go,*.html,*.css,*.json,*.yaml,*.yml,*.md,*.py,*.java,*.sh,*.bash,*.tsx,*.ts,*.jsx lua vim.lsp.buf.format() 
  augroup END
]]

