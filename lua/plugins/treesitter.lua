return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		})
		vim.schedule(function()
			print("")
		end)

    vim.keymap.set("n", "<leader>sa", function()
  local cpp_file = vim.fn.expand("%:p")
  local asm_file = vim.fn.expand("%:p:r") .. ".s"
  local cmd = "g++ -S -O2 " .. cpp_file .. " -o " .. asm_file

  vim.fn.jobstart(cmd, {
    on_exit = function()
      vim.schedule(function()
        vim.cmd("vsplit " .. asm_file)
      end)
    end,
  })
end, { desc = "Compile to Assembly and View" })

	end,
}
