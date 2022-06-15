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

function lookForIndentation(direction)
  -- Go to beggin of line and add to jump list
  execute('normal'..line('.')..'G^')

  jumpUntilNotEmptyLine(direction)

  execute('normal'..getSameIndentLine(direction)..'G^')
end

function arrayElement(t)
  local i = 0

  return function()
    i = i + 1
    return t[i]
  end
end
