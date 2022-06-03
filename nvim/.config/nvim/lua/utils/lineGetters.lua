local keymap = vim.keymap
local line = vim.fn.line
local indent = vim.fn.indent

keymap.set('n', "<bs>", function()
  getSameIndentLine('j')
end, { noremap = true, silent = true })

local line = vim.fn.line

local function getProps(direction)
  if direction == 'j' then
    return 1, line('$')
  elseif direction == 'k' then
    return -1, 1
  end
end

function getSameIndentLine(direction)
  local inc, endOfFile = getProps(direction)
  local lineMarker = line('.')
  local existsSameIndent = false
  local originalIndent = indent('.')

  while not existsSameIndent and lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc
    existsSameIndent = indent(lineMarker) == originalIndent
    -- We stap here

  end
end
