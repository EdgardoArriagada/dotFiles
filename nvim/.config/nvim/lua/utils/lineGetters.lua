local keymap = vim.keymap
local line = vim.fn.line
local indent = vim.fn.indent

-- to debug
--keymap.set('n', "<bs>", function()
--  local lol = getSameIndentLine('j')
--end, { noremap = true, silent = true })

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

    if existsSameIndent and isEmptyLine(lineMarker) then
      existsSameIndent = false
    end
  end

  if existsSameIndent then
    return lineMarker
  else
    return line('.')
  end
end

function getLastMatchingIndent(direction)
  local inc, endOfFile = getProps(direction)

  local lineMarker = line('.')
  local originalIndent = indent('.')

  while lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc
    existsSameIndent = indent(lineMarker) == originalIndent

    if not (existsSameIndent or isEmptyLine(lineMarker)) then
      break
    end
  end

  return lineMarker
end

-- func! GetStopLine(direction)
  -- let [inc, endOfFile] = s:getProps(a:direction)

  -- let lineMarker = line('.')
  -- let s:isStartEmpty = IsEmptyLine(lineMarker)
  -- let s:originalIndent = indent('.')

  -- func! s:didSwitch(line)
    -- if s:isStartEmpty == 1
      -- return !IsEmptyLine(a:line)
    -- else
      -- return IsEmptyLine(a:line)
    -- endif
  -- endfunc

  -- while !s:didSwitch(lineMarker) && lineMarker != endOfFile
    -- let lineMarker += inc

    -- if !IsEmptyLine(lineMarker) && indent(lineMarker) < s:originalIndent
      -- let lineMarker -= inc
      -- break
    -- endif
  -- endwhile

  -- return lineMarker
-- endfunc
