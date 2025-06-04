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
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    opts = {
      handlers = {}
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

      -- Keymaps
      vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "Start/Continue Debugger" })
  vim.keymap.set("n", "<leader>dus", function()
  local widgets = require('dap.ui.widgets')
  local sidebar = widgets.sidebar(widgets.scopes)
  sidebar.open()
end, { desc = "Open debugging sidebar" })
    


      vim.keymap.set("n", "<Leader>dr", dap.continue, { desc = "Run Debugger" })

      vim.keymap.set("n", "<leader>dv", function()
        local var = vim.fn.input("Variable name: ")
        local cmd = "p &" .. var
        require("dap").repl.open()
        require("dap").repl.send(cmd)
      end, { desc = "Print Address of Variable" })

    vim.keymap.set("n", "<leader>dgt", function()
      require("dap-go").debug_test()
    end, { desc = "Debug go test" })

    vim.keymap.set("n", "<leader>dgl", function()
      require("dap-go").debug_last()
    end, { desc = "Debug last go test" })

      vim.keymap.set("n", "<leader>dm", function()
        local addr = vim.fn.input("Memory address: ")
        if addr == "" then return end

        local dap = require("dap")
        local repl = require("dap.repl")

        if not dap.session() then
          vim.notify("No active debug session", vim.log.levels.WARN)
          return
        end

        repl.open()
        local cmd = "memory read --format x --size 4 --count 4 " .. addr
        repl.execute(cmd)
        vim.cmd("wincmd p")
      end, { desc = "Inspect Memory at Address" })
    end,
  },
}

