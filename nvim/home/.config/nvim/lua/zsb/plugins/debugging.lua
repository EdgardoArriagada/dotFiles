return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "leoluz/nvim-dap-go",
  },
	keys = { "<leader>db" },
  config = Config("dap", function(dap)
    local dapui = require("dapui")

    require("dap-go").setup()
    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    kset("n", "<Leader>dc", dap.continue)
    kset("n", "<Leader>do", dap.step_over)
    kset("n", "<Leader>di", dap.step_into)
    kset("n", "<Leader>dx", dap.step_out)
    kset("n", "<Leader>db", dap.toggle_breakpoint)
    --[[ kset("n", "<Leader>dx", dap.set_breakpoint) ]]
    --[[ kset("n", "<Leader>dm", function() ]]
    --[[   dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) ]]
    --[[ end) ]]
    kset("n", "<Leader>dr", dap.repl.open)
    kset("n", "<Leader>dl", dap.run_last)
    kset({ "n", "v" }, "<Leader>dh", function()
      require("dap.ui.widgets").hover()
    end)
    kset({ "n", "v" }, "<Leader>dp", function()
      require("dap.ui.widgets").preview()
    end)
    kset("n", "<Leader>df", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end)
    kset("n", "<Leader>ds", function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end)
  end),
}
