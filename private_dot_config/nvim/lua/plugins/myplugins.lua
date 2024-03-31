local plugins = {
  {
  "ellisonleao/carbon-now.nvim",
  lazy = true,
  cmd = "CarbonNow",
  opts = {
    options = {
      watermark= false,
      theme= "one-dark",
      titlebar="foglar's code"
      },
    },
  },
--  { "nvim-neotest/nvim-nio" },
--  {
--    "christoomey/vim-tmux-navigator",
--    lazy = false,
--  },
--  {
--    "leoluz/nvim-dap-go",
--    ft = "go",
--    dependencies = "mfussenegger/nvim-dap",
--    config = function (_, opts)
--      require("dap-go").setup(opts)
--    end
--  },
--  {
--    "jay-babu/mason-nvim-dap.nvim",
--    event = "VeryLazy",
--    dependencies = "williamboman/mason.nvim",
--    "mfussenegger/nvim-dap",
--    opts = {
--      handlers = {},
--      ensure_installed = {
--        "codelldb",
--      }
--    },
--  },
--  {
--    "rcarriga/nvim-dap-ui",
--    event = "VeryLazy",
--    dependencies = "mfussenegger/nvim-dap",
--    config = function ()
--      local dap = require("dap")
--      local dapui = require("dapui")
--      dapui.setup()
--      dap.listeners.after.event_initialized["dapui_config"] = function ()
--        dapui.open()
--      end
--      dap.listeners.before.event_terminated["dapui_config"] = function ()
--        dapui.close()
--      end
--      dap.listeners.before.event_exited["dapui_config"] = function ()
--        dapui.close()
--      end
--    end
--  },
--  {
--    "mfussenegger/nvim-dap",
--    config = function (_, _)
--      require("core.utils").load_mappings("dap")
--    end
--  },
--  {
--    "mfussenegger/nvim-dap-python",
--    ft = "python",
--    dependencies = {
--      "mfussenegger/nvim-dap",
--      "rcarriga/nvim-dap-ui",
--    },
--    config = function (_, _)
--      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
--      require("dap-python").setup(path)
--      require("core.utils").load_mappings("dap_python")
--    end,
--  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    ft = {"python"},
    opts = function ()
      return require "configs.null-ls"
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "clangd",
        "clang-format",
        "codelldb",
        "debugpy",
        "pyright",
        "mypy",
        "ruff",
        "gopls",
      },
    },
  },
  {
  "neovim/nvim-lspconfig",
  config = function ()
    require "nvchad.configs.lspconfig"
    require "configs.lspconfig"
  end,
  },
}

return plugins
