return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    -- ✅ Define augroup once and reuse it
    local format_group = vim.api.nvim_create_augroup("Format", { clear = true })

    null_ls.setup({
      sources = {
        -- Formatters
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.gofmt,
        null_ls.builtins.formatting.goimports,
        null_ls.builtins.formatting.golines,

        -- Diagnostics
        null_ls.builtins.diagnostics.mypy,
        null_ls.builtins.diagnostics.ruff,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.diagnostics.clang_check,
        null_ls.builtins.diagnostics.cpplint,
        null_ls.builtins.diagnostics.cppcheck.with({
          args = {
            "--enable=all",
            "--inconclusive",
            "--std=c++20",
            "--template=gcc",
            "--quiet",
            "$FILENAME",
          },
        }),
      },

      -- 🛠 Auto-format on save
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
        end
      end,
    })

    -- 🧼 Manual formatting keymap
    vim.keymap.set("n", "<leader>fm", function()
      vim.notify("Running formatter...")
      vim.lsp.buf.format({ async = true })
    end, { desc = "Manual format" })
  end,
}

