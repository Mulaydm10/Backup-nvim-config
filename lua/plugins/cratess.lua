return {
  {
  "saecki/crates.nvim",
  tag = "stable",
  dependencies = { "nvim-lua/plenary.nvim" }, -- required dependency
  event = { "BufRead Cargo.toml" },           -- lazy load only for Cargo.toml
  config = function()
    require("crates").setup({
      smart_insert = true,
      insert_closing_quote = true,
      avoid_prerelease = false,
      autoload = true,
      autoupdate = true,
      loading_indicator = true,
      date_format = "%Y-%m-%d",
      thousands_separator = ",",
      notification_title = "Crates",
      curl_args = { "-sL", "--retry", "3" },
      disable_invalid_feature_diagnostic = false,

      popup = {
        autofocus = true,
        border = "rounded",
        show_version_date = true,
        show_dependency_version = true,
      },

      src = {
        cmp = { enabled = true },
      },
    })

    -- Keymaps (optional but useful)
    local crates = require("crates")
    vim.keymap.set("n", "<leader>cu", crates.update_crate, { desc = "Update Crate" })
    vim.keymap.set("n", "<leader>ca", crates.update_all_crates, { desc = "Update All Crates" })
    vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Show Versions" })
    vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Show Features" })
    vim.keymap.set("n", "<leader>cd", crates.open_documentation, { desc = "Open Docs.rs" })
  end,
}
}
