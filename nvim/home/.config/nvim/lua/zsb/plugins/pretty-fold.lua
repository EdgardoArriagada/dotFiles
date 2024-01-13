-- if vim.v.foldlevel = 2 then spaces = 2
-- if vim.v.foldlevel = 3 then spaces = 4
-- if vim.v.foldlevel = 4 then spaces = 6
-- if vim.v.foldlevel = 5 then spaces = 8
-- ...
--
--
return {
  "anuvyklack/pretty-fold.nvim",
  ft = { "json" },
  config = Config("pretty-fold", function(prettyFold)
    local calculateSpaces = function(foldLevel)
      if foldLevel <= 2 then
        return foldLevel
      end
      return (foldLevel * 2) - 2
    end

    prettyFold.setup({
      keep_indentation = false,
      fill_char = "━",
      sections = {
        left = {
          "",
          function()
            return string.rep("·", calculateSpaces(vim.v.foldlevel) - 2)
          end,
          "content",
          "┣",
        },
        right = {
          "┫ ",
          "number_of_folded_lines",
          ": ",
          "percentage",
          " ┣━━",
        },
      },
    })
  end),
}
