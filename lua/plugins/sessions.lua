return {
  "rmagatti/auto-session",
  config = function()
    require("auto-session").setup({
      auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
      session_lens = {
        buftypes_to_ignore = {}, -- optional: ignore certain buffer types
        load_on_setup = true,    -- initialize on startup
        theme_conf = { border = true },
        previewer = false,
      }
    })

    vim.keymap.set("n", "<Leader>ls", require("auto-session.session-lens").search_session, {
      noremap = true,
    })
  end,
}

