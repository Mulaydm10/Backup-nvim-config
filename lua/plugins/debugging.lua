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
    end,
  },
}

