return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  config = Config("ibl", function(ibl)
    local hooks = require("ibl.hooks")

    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    end)

    ibl.setup({
      indent = { char = "│" },
      whitespace = {
        remove_blankline_trail = false,
      },
      scope = { enabled = true, highlight = "RainbowViolet" },
    })
  end),
}
