return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      auto_install = true,
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls", -- ⛔️ FIX: Should be "tsserver" not "ts_ls"
          "clangd",
          "gopls",
          "rust_analyzer",
          "pyright",
          "ruff",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local util = require("lspconfig.util")

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local on_attach = function(_, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- Lua
      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- TypeScript
      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      -- C/C++
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = util.root_pattern("compile_commands.json", ".git"),
      })

      -- Go
      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "gopls" },
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = util.root_pattern("go.work", "go.mod", ".git"),
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          },
        },
      })

      -- Python
      lspconfig.pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "python" },
      })

      -- 🦀 Rust is handled by rustaceanvim, do not add rust_analyzer here
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(_, bufnr)
            local opts = { noremap = true, silent = true, buffer = bufnr }
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
          end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = { command = "clippy" },
              inlayHints = {
                chainingHints = { enable = true },
                parameterHints = { enable = true },
                typeHints = { enable = true },
              },
            },
          },
        },
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = false,
        show_stop_reason = true,
        commented = false,
        only_first_definition = true,
        all_references = false,
        clear_on_continue = false,
        virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
        all_frames = false,
        virt_lines = false,
        virt_text_win_col = nil,
        display_callback = function(variable, _, _, _, opts)
          local val = variable.value:gsub("%s+", " ")
          return opts.virt_text_pos == "inline" and (" = " .. val) or (variable.name .. " = " .. val)
        end,
      })
    end,
  },
}
