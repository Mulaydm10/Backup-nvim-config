return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
  },

  {
    "leoluz/nvim-dap-go",
    ft = "go",
    config = function()
      require("dap-go").setup()
    end,
  },

  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    config = function()
      local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      handlers = {},
    },
    config = function()
      local dap_ok, dap = pcall(require, "dap")
      local dapui_ok, dapui = pcall(require, "dapui")
      if not dap_ok or not dapui_ok then return end

      dapui.setup()

      dap.listeners.before.attach.dapui_config = function() dapui.open() end
      dap.listeners.before.launch.dapui_config = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      dap.adapters.lldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
          args = { "--port", "${port}" },
        },
        name = "codelldb",
      }

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

      dap.configurations.c = dap.configurations.cpp
      dap.configurations.rust = dap.configurations.cpp

      -- Keymaps
      local map = vim.keymap.set
      map("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      map("n", "<Leader>dc", dap.continue, { desc = "Start/Continue Debugger" })

      map("n", "<leader>dus", function()
        local widgets = require("dap.ui.widgets")
        local sidebar = widgets.sidebar(widgets.scopes)
        sidebar.open()
      end, { desc = "Open Debug Sidebar" })

      map("n", "<Leader>dr", dap.continue, { desc = "Run Debugger" })

      map("n", "<leader>dv", function()
        local var = vim.fn.input("Variable name: ")
        local cmd = "p &" .. var
        require("dap").repl.open()
        require("dap").repl.send(cmd)
      end, { desc = "Print Address of Variable" })

      map("n", "<leader>dgt", function()
        require("dap-go").debug_test()
      end, { desc = "Debug Go Test" })

      map("n", "<leader>dgl", function()
        require("dap-go").debug_last()
      end, { desc = "Debug Last Go Test" })

      map("n", "<leader>dm", function()
        local addr = vim.fn.input("Memory address: ")
        if addr == "" then return end

        if not dap.session() then
          vim.notify("No active debug session", vim.log.levels.WARN)
          return
        end

        local repl = require("dap.repl")
        repl.open()
        local cmd = "memory read --format x --size 4 --count 4 " .. addr
        repl.execute(cmd)
        vim.cmd("wincmd p")
      end, { desc = "Inspect Memory" })
    end,
  },
}

