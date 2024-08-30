kset({ "o", "n", "v" }, "<bs>", function()
  GoLessDeeperIndent("k")
end, { silent = true })

kset({ "o", "n", "v" }, "<enter>", function()
  -- I use enter to unfold lines as well
  if IsCurrentLineFolded() then
    Exec("normal! zO")
  else
    GoLessDeeperIndent("j")
  end
end, { silent = true })

function GoLessDeeperIndent(direction)
  -- Go to beggin of line and add to jump list
  Exec("normal^m'")

  local lineMarker = GetFirstNoEmptyLine(direction, line("."))

  local originalInent = indent(lineMarker)

  if originalInent == 0 then
    local lastLine = GetSameIndentLin(direction, lineMarker)
    Exec("normal" .. lastLine .. "G^")
    return
  end

  local lastMatchinLine = GetLesserIndent(direction, lineMarker)

  Exec("normal" .. lastMatchinLine .. "G^")
end
