local getCurrentLine = vim.api.nvim_get_current_line
local getpos = vim.fn.getpos
local setpos = vim.fn.setpos
local col = vim.fn.col
local line = vim.fn.line

local function execute(str)
  vim.cmd(vim.api.nvim_replace_termcodes(str, true, true, true))
end

local function tokenPairs(t)
  local i = 0

  return function()
    i = i + 2
    return t[i - 1], t[i]
  end
end

local pairList = {
  '(', ')',
  '[', ']',
  '{', '}',
  '<', '>',
}

local function didSelectInLine()
  return col('.') ~= col('v') and line('.') == line('v')
end

local function hasPair(left, right)
  local currentLine = getCurrentLine()
  local foundLeft = false
  for c in currentLine:gmatch"." do
    if foundLeft then
      if c == right then return true end
    else
      if c == left then foundLeft = true end
    end
  end
end

function main()
  local savedPos = getpos('.')
  local cachedPair = {}
  for left, right in tokenPairs(pairList) do
    if not hasPair(left, right) then goto continue end

    table.insert(cachedPair, {left, right})
    execute('normal <Esc> vi'..left)

    if didSelectInLine() then
      return
    end

    setpos('.', savedPos)

    ::continue::
  end
end

return {
  main = main,
}
