return {
  "EdgardoArriagada/vaquero-shoot.nvim",
  --[[ dir = "~/projects/per/vaquero-shoot.nvim", ]]
  keys = { "W", "E", { "W", mode = "v" }, { "E", mode = "v" }, { "'", mode = "v" }, { '"', mode = "v" } },
  config = Config("vaquero-shoot", function(vqs)
    -- enclosing
    kset("n", "E", function()
      vqs.beginEnclosingSelection()
    end)

    kset("v", "E", function()
      vqs.cycleEnclosingSelection()
    end)

    kset("n", "W", function()
      vqs.beginEnclosingSelectionBackwards()
    end)

    kset("v", "W", function()
      vqs.cycleEnclosingSelectionBackwards()
    end)

    -- quotes
    kset({ "o", "v" }, "'", function()
      vqs.quotesSelection()
    end)

    kset({ "o", "v" }, '"', function()
      vqs.quotesSelectionBackwards()
    end)
  end),
}
