local line = vim.fn.line

function strip(input)
   return (input:gsub("^%s*(.-)%s*$", "%1"))
end

function isEmptyString(input)
  if #input == 0 then return true end

  return #strip(input) == 0
end

function isEmptyLine(line)
  return isEmptyString(vim.fn.getline(line))
end

function isCursorWithinBuffer()
  return 1 < line('.') and line('.') < line('$')
end

function jumpUntilNotEmptyLine(direction)
  while isEmptyLine('.') and isCursorWithinBuffer() do
    execute('normal '..direction..'^')
  end
end

