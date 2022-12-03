keymap.set('v', '<tab>', function()
  SmartTab('j')
end, { noremap = true, silent = true })

keymap.set('v', '<s-tab>', function()
  SmartTab('k')
end, { noremap = true, silent = true })

-- Direction is either 'j' or 'k'
function SmartTab(direction)
  local beforeLine = line('.')
  execute('normal^')

  -- Add to jump list
  execute('normal'..line('.')..'G')

  execute('normal'..getStopLine(direction)..'G^')

  if beforeLine == line('.') then
    execute('normal!'..direction..'^')
  end
end

