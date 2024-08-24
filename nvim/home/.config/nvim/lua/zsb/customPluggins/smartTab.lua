kset('v', '<tab>', function()
  SmartTab('j')
end, { noremap = true, silent = true })

kset('v', '<s-tab>', function()
  SmartTab('k')
end, { noremap = true, silent = true })

-- Direction is either 'j' or 'k'
function SmartTab(direction)
  local beforeLine = line('.')
  Exec('normal^')

  -- Add to jump list
  Exec('normal'..line('.')..'G')

  Exec('normal'..getStopLine(direction)..'G^')

  if beforeLine == line('.') then
    Exec('normal!'..direction..'^')
  end
end

