return {
  "EdgardoArriagada/search-replace.nvim",
  --[[ dir = "~/projects/per/search-replace.nvim", ]]
  keys = { { "<c-r>", mode = "v" } },
  config = Config("search-replace", function(sr)
    kset("v", "<c-r>", function()
      sr.searchAndReplace("<c-r>")
    end)
  end),
}
