return {
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    config = function(_, opts)
      require("gopher").setup(opts)

      -- Keybindings
      vim.keymap.set("n", "<leader>gsj", "<cmd>GoTagAdd json<CR>", { desc = "Add JSON struct tags", noremap = true, silent = true })
      vim.keymap.set("n", "<leader>gsy", "<cmd>GoTagAdd yaml<CR>", { desc = "Add YAML struct tags", noremap = true, silent = true })
    end,
    build = function()
      vim.cmd([[silent! GoInstallDeps]])
    end,
  },
}

