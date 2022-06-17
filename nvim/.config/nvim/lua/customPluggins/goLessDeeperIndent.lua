keymap.set({ 'o', 'n', 'v' }, '<bs>', function()
  goLessDeeperIndent('k')
end, { silent = true })

keymap.set({ 'o', 'n', 'v' }, '<enter>', function()
  goLessDeeperIndent('j')
end, { silent = true })

function goLessDeeperIndent(direction)
  -- Go to beggin of line and add to jump list
  execute('normal'..line('.')..'G^')

  local originalInent = indent('.')

  if originalInent == 0 then
    local lastLine = getSameIndentLine(direction)
    execute('normal'..lastLine..'G^')
    return
  end

  local lineMarker = getFirstNoEmptyLine(direction, line('.'))

  local lastMatchinLine = getLesserIndent(direction, lineMarker)

  execute('normal'..lastMatchinLine..'G^')
end
