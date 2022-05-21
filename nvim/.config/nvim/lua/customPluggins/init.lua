local getCurrentLine = vim.api.nvim_get_current_line

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

local function hasChar(inputChar)
  return string.match(getCurrentLine(), '\\' .. inputChar)
end

local function hasPair(left, right)
  return hasChar(left) and hasChar(right)
end

_G.powerSelection = function()
  for left, right in tokenPairs(pairList) do
    if not hasPair(left, right) then
      print('not' ..left..right)
    end
  end
end

