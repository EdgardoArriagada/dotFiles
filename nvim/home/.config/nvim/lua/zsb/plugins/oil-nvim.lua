return {
  "stevearc/oil.nvim",
  keys = { "-" },
  opts = {},

  config = function()
    Hpcall(require, "oil", {
      onOk = function(oil)
        oil.setup()
        kset("n", "-", oil.open, { noremap = true })
      end,
      onErr = "Failed to load vaquero-shoot.nvim",
    })
  end,

  -- Optional dependencies
  dependencies = { "kyazdani42/nvim-web-devicons" },
}
