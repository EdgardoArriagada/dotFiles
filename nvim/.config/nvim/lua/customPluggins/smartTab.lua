keymap.set('v', '<tab>', function()
  smartTab('j')
end, { noremap = true, silent = true })

keymap.set('v', '<s-tab>', function()
  smartTab('k')
end, { noremap = true, silent = true })

-- Direction is either 'j' or 'k'
function smartTab(direction)
  local beforeLine = line('.')
  execute('normal ^')

  -- Add to jump list
  execute('normal'..line('.')..'G')

  execute('normal!'..getStopLine(direction)..'G^')

  if beforeLine == line('.') then
    execute('normal'..direction..'^')
  end
end

