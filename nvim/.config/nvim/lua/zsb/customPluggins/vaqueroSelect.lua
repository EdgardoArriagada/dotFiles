keymap.set('v', 'q', function()
  execute('normal<Esc>')
  VaqueroSelect()
end, { noremap = true, silent = true })

keymap.set('o', 'q', function()
  VaqueroSelect()
end, { noremap = true, silent = true })

function VaqueroSelect()
  GoLessDeeperIndent('k')
  execute('normal!V')
  lookForIndentation('j')
end
