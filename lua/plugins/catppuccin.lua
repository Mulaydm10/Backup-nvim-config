 
return {
  "catppuccin/nvim", 
  name = "catppuccin",
  priority = 1000,
  config = function()
    vim.cmd.colorscheme "catppuccin"
    vim.opt.guifont = "YourFontName:h14"  -- Font setup
  end  
}

