function getDirectionalProps(direction)
  if direction == 'j' then
    return 1, line('$')
  elseif direction == 'k' then
    return -1, 1
  end
end

function isEmptyString(input)
  for c in input:gmatch"." do
    if c ~= " " then return false end
  end

  return true
end

function isEmptyLine(line)
  return isEmptyString(vim.fn.getline(line))
end

function isCursorWithinBuffer()
  return 1 < line('.') and line('.') < line('$')
end

function jumpUntilNotEmptyLine(direction)
  while isEmptyLine('.') and isCursorWithinBuffer() do
    execute('normal!'..direction..'^')
  end
end

function getFirstNoEmptyLine(direction, lineMarker)
  local inc, endOfFile = getDirectionalProps(direction)
  while lineMarker ~= endOfFile do
    if not isEmptyLine(lineMarker) then
      return lineMarker
    end

    lineMarker = lineMarker + inc
  end
  return lineMarker
end

function lookForIndentation(direction)
  -- Go to beggin of line and add to jump list
  execute('normal'..line('.')..'G^')

  local lineMarker = getFirstNoEmptyLine(direction, line('.'))

  execute('normal'..getSameIndentLine(direction, lineMarker)..'G^')
end

function arrayElement(t)
  local i = 0

  return function()
    i = i + 1
    return t[i]
  end
end
