local getCurrentLine = vim.api.nvim_get_current_line
local getPos = vim.api.nvim_win_get_cursor

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
  local savedPos = getPos(0)
  local cachedPair = {}
  for left, right in tokenPairs(pairList) do
    if not hasPair(left, right) then goto continue end

    table.insert(cachedPair, {left, right})
    execute('normal <Esc> vi'..left)
  end

  ::continue::
end

return {
  main = main,
}
