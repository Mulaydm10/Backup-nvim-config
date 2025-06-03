return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      handlers = {}
    },
    config = function()
      local dap_ok, dap = pcall(require, "dap")
      local dapui_ok, dapui = pcall(require, "dapui")
      if not dap_ok or not dapui_ok then return end

      -- Setup dap-ui
      dapui.setup()

      -- Open/close dapui on debugger events
      dap.listeners.before.attach["dapui_config"] = function() dapui.open() end
      dap.listeners.before.launch["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Adapter for codelldb installed by Mason
      dap.adapters.lldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
        name = "codelldb",
      }

      -- Configuration for C++ debugging
      dap.configurations.cpp = {
        {
          name = "Launch file",
          type = "lldb",
          request = "launch",
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
          runInTerminal = false,
        },
      }
      -- Use same config for C
      dap.configurations.c = dap.configurations.cpp

      -- Keymaps
      vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Start/Continue Debugger" })
      vim.keymap.set("n", "<Leader>dr", function()
        dap.continue()
      end, { desc = "Run Debugger" })
      vim.keymap.set("n", "<leader>dv", function()
  local var = vim.fn.input("Variable name: ")
  local cmd = "p &" .. var
  require("dap").repl.open()
  require("dap").repl.send(cmd)
end, { desc = "Print Address of Variable" })

vim.keymap.set("n", "<leader>dm", function()
  local addr = vim.fn.input("Memory address: ")
  if addr == "" then
    return
  end
  
  local dap = require("dap")
  local repl = require("dap.repl")
  
  -- Check if debugging session is active
  if not dap.session() then
    vim.notify("No active debug session", vim.log.levels.WARN)
    return
  end
  
  -- Open REPL if not already open
  repl.open()
  
  -- Send memory read command using the proper API
  local cmd = "memory read --format x --size 4 --count 4 " .. addr
  repl.execute(cmd)
  
  -- Focus on the REPL window to see the output
  vim.cmd("wincmd p")
end, { desc = "Inspect Memory at Address" })
    end,
  },
}

