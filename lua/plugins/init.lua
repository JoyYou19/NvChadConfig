return {
  {
    "stevearc/conform.nvim",
    config = function()
      require "configs.conform"
    end,
  },

  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      git = { enable = true },

actions = {
       open_file = {
           quit_on_open = true
       }
   }
    },
  },
{
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
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
  {"github/copilot.vim", lazy = false},
{
  "neovim/nvim-lspconfig",
  config = function()
      require("nvchad.configs.lspconfig").defaults()
      require "configs.lspconfig"
   end,
},
{ "elentok/format-on-save.nvim" },
  {
"saecki/crates.nvim",
    ft = {"rust", "toml"},
    config = function(_, opts)
   local crates = require('crates')
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
        ensure_installed = { "c", "cpp", "prisma", "rust", "toml" },
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
          javascript = { "eslint_d" },
          typescript = { "eslint_d" },
          javascriptreact = { "eslint_d" },
          typescriptreact = { "eslint_d" },
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


