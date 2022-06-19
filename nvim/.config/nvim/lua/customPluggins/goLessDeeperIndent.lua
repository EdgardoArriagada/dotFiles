keymap.set({ 'o', 'n', 'v' }, '<bs>', function()
  goLessDeeperIndent('k')
end, { silent = true })

keymap.set({ 'o', 'n', 'v' }, '<enter>', function()
  goLessDeeperIndent('j')
end, { silent = true })

function goLessDeeperIndent(direction)
  -- Go to beggin of line and add to jump list
  execute("normal^m'")

  local lineMarker = getFirstNoEmptyLine(direction, line('.'))

  local originalInent = indent(lineMarker)

  if originalInent == 0 then
    local lastLine = getSameIndentLine(direction, lineMarker)
    execute('normal'..lastLine..'G^')
    return
  end

  local lastMatchinLine = getLesserIndent(direction, lineMarker)

  execute('normal'..lastMatchinLine..'G^')
end
