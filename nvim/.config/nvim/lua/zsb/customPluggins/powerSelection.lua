keymap.set('n', 'W', function()
  powerSelection()
end)

keymap.set('v', 'W', function()
  execute('normal<Esc><Right><Right>')
  powerSelection()
end)

local set = {
  ["("] = true,
  [")"] = true,
  ["["] = true,
  ["]"] = true,
  ["{"] = true,
  ["}"] = true,
  ["<"] = true,
  [">"] = true,
}

local rightToLeft = {
  [")"] = "(",
  ["]"] = "[",
  ["}"] = "{",
  [">"] = "<",
}

local leftSet = {
  ["("] = true,
  ["["] = true,
  ["{"] = true,
  ["<"] = true,
}

local function safePush(pile, element, i)
  if not pile[element] then
    pile[element] = { i }
  else
    table.insert(pile[element], i)
  end
end

local function safePop(pile, element)
  if not pile[element] then return false end
  return table.remove(pile[element])
end

local function loadToken(pairsHolder, pileHolder, token, i)
  if leftSet[token] then
    safePush(pileHolder, token, i)
    return
  end

  local leftToken = rightToLeft[token]
  local leftIndex = safePop(pileHolder, leftToken)

  if leftIndex ~= false then
    safePush(pairsHolder, leftToken, { leftIndex, i }) -- where token = leftToken
  end
end

local function loadHolder(pairsHolder)
  local pileHolder = {}
  local currentLine = getCurrentLine()
  local i = 0
  for c in currentLine:gmatch"." do
    if set[c] then loadToken(pairsHolder, pileHolder, c, i) end
    i = i + 1
  end
end

local function selectMoving(leftIndex, rightIndex)
  local lineNumber = line('.')
  cursor(lineNumber, leftIndex + 2)
  execute('normal<Esc>v')
  cursor(lineNumber, rightIndex)
end

function powerSelection()
  local currPos = col('.') - 1
  local pairsHolder = {}
  loadHolder(pairsHolder)

  local closest = false
  for key in pairs(pairsHolder) do
    for left, right in toupleArrayElement(pairsHolder[key]) do
      if left <= currPos and currPos <= right then
        if not closest then closest = { left, right } else
          if closest[1] < left then
            closest = { left, right }
          end
        end
      end
    end
  end

  if closest then
    selectMoving(closest[1], closest[2])
    return
  end

  closest = false
  for key in pairs(pairsHolder) do
    for left, right in toupleArrayElement(pairsHolder[key]) do
      if currPos < left and currPos < right then
        if not closest then closest = { left, right } else
          if left < closest[1] then
            closest = { left, right }
          end
        end
      end
    end
  end

  if closest then
    selectMoving(closest[1], closest[2])
    return
  end

  closest = false
  for key in pairs(pairsHolder) do
    for left, right in toupleArrayElement(pairsHolder[key]) do
      if left < currPos and right < currPos then
        if not closest then closest = { left, right } else
          if closest[2] < right then
            closest = { left, right }
          end
        end
      end
    end
  end

  if closest then
    selectMoving(closest[1], closest[2])
  end
end
