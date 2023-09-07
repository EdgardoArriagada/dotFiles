kset('v', '<tab>', function()
  SmartTab('j')
end, { noremap = true, silent = true })

kset('v', '<s-tab>', function()
  SmartTab('k')
end, { noremap = true, silent = true })

-- Direction is either 'j' or 'k'
function SmartTab(direction)
  local beforeLine = line('.')
  Execute('normal^')

  -- Add to jump list
  Execute('normal'..line('.')..'G')

  Execute('normal'..getStopLine(direction)..'G^')

  if beforeLine == line('.') then
    Execute('normal!'..direction..'^')
  end
end

