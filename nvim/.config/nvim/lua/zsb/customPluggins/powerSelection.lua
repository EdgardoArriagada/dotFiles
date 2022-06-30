keymap.set('n', 'Q', function()
  powerSelection()
end, { noremap = true, silent = true })

local function loadToken(holder, token, i)
  if not holder[token] then
    holder[token] = { i }
  else
    table.insert(holder[token], i)
  end
end

local set = {}
set["("] = true
set[")"] = true
set["["] = true
set["]"] = true
set["{"] = true
set["}"] = true
set["<"] = true
set[">"] = true

local function loadHolder(holder)
  local currentLine = getCurrentLine()
  local i = 0
  for c in currentLine:gmatch"." do
    if set[c] then loadToken(holder, c, i) end
    i = i + 1
  end
end


local pairList = {
  '(', ')',
  '[', ']',
  '{', '}',
  '<', '>',
}

local function tokenPairs(t)
  local i = 0

  return function()
    i = i + 2
    return t[i - 1], t[i]
  end
end

local function arrayElement(t)
  local i = 0

  return function()
    i = i + 1
    return t[i]
  end
end

local function hasPair(left, right, holder)
  return holder[left] and holder[right]
end

local function isBetweenTokens(inPos, holder, left, right)
  for leftIndex in arrayElement(holder[left]) do
    if leftIndex <= inPos then
      for rightIndex in arrayElement(holder[right]) do
        if rightIndex >= inPos then return true end
      end
    end
  end
end

local function getIndexOfAfterToken(inPos, holder, left, right)
  for leftIndex in arrayElement(holder[left]) do
    if inPos < leftIndex  then
      for rightIndex in arrayElement(holder[right]) do
        if leftIndex < rightIndex then return leftIndex end
      end
    end
  end
end

local function getIndexOfBeforeToken(inPos, holder, left, right)
  for leftIndex in arrayElement(holder[left]) do
    if leftIndex < inPos then
      for rightIndex in arrayElement(holder[right]) do
        if leftIndex < rightIndex then return leftIndex end
      end
    end
  end
end

function powerSelection()
  local inPos = col('.')
  local holder = {}
  loadHolder(holder)
  local cachedPair = {}

  for left, right in tokenPairs(pairList) do
    if not hasPair(left, right, holder) then goto continue end

    table.insert(cachedPair, left)
    table.insert(cachedPair, right)

    if (isBetweenTokens(inPos, holder, left, right)) then
      execute('normal<Esc>vi'..left)
      return
    end

    ::continue::
  end

  for left, right in tokenPairs(cachedPair) do
    local indexLeft = getIndexOfAfterToken(inPos, holder, left, right)
    if (indexLeft) then
      cursor(line('.'), indexLeft + 2)
      execute('normal<Esc>vt'..right)
      return
    end
  end

  for left, right in tokenPairs(cachedPair) do
    local indexLeft = getIndexOfBeforeToken(inPos, holder, left, right)
    if (indexLeft) then
      cursor(line('.'), indexLeft + 2)
      execute('normal<Esc>vt'..right)
      return
    end
  end
end
