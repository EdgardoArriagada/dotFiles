keymap.set({ 'o', 'n', 'v' }, '<bs>', function()
  goLessDeeperIndent('k')
end, { noremap = true, silent = true })

keymap.set({ 'o', 'n', 'v' }, '<enter>', function()
  goLessDeeperIndent('j')
end, { noremap = true, silent = true })

function goLessDeeperIndent(direction)
  -- Go to beggin of line and add to jump list
  execute('normal'..line('.')..'G^')

  jumpUntilNotEmptyLine(direction)

  local originalInent = indent('.')

  if originalInent == 0 then
    local lastLine = getSameIndentLine(direction)
    execute('normal'..lastLine..'G^')
    return
  end

  while col('.') > 1 do
    local lastMatchinLine = getLastMatchingIndent(direction)
    execute('normal'..lastMatchinLine..'G^')

    if indent('.') < originalInent then
      break
    end
  end
end
