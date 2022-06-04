keymap.set('v', 'q', function()
  execute('normal <Esc>')
  vaqueroSelect()
end, { noremap = true, silent = true })

keymap.set('o', 'q', function()
  vaqueroSelect()
end, { noremap = true, silent = true })

function vaqueroSelect()
  goLessDeeperIndent('k')
  execute('normal V')
  lookForIndentation('j')
end
