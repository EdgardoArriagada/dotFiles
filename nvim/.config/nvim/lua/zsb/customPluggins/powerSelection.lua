keymap.set('n', 'W', function()
  beginPowerSelection()
end)

keymap.set('v', 'W', function()
  cyclePowerSelection()
end)

local str = {
  enclosing = {
    set = {
      ["("] = true,
      [")"] = true,
      ["["] = true,
      ["]"] = true,
      ["{"] = true,
      ["}"] = true,
      ["<"] = true,
      [">"] = true,
    },
    rightToLeft = {
      [")"] = "(",
      ["]"] = "[",
      ["}"] = "{",
      [">"] = "<",
    },
    leftSet = {
      ["("] = true,
      ["["] = true,
      ["{"] = true,
      ["<"] = true,
    },
    loadToken = function(pairsHolder, pileHolder, token, i)
      if str.enclosing.leftSet[token] then
        safePush(pileHolder, token, i)
        return
      end

      local leftToken = str.enclosing.rightToLeft[token]
      local leftIndex = safePop(pileHolder, leftToken)

      if leftIndex ~= nil then
        safePush(pairsHolder, leftToken, { leftIndex, i }) -- where token = leftToken
      end
    end
  },
  quotes = {
    set = {
      ["'"] = true,
      ['"'] = true,
      ['`'] = true,
    },
    rightToLeft = {
      ["'"] = "'",
      ['"'] = '"',
      ['`'] = '`',
    },
    leftSet = {
      ["'"] = true,
      ['"'] = true,
      ['`'] = true,
    },
    loadToken = function (holder, pileHolder, token, i)
      local leftIndex = safePop(pileHolder, token)

      if leftIndex ~= nil then
        safePush(holder, token, { leftIndex, i })
        return
      end

      safePush(pileHolder, token, i)
    end,
  },
}

local function loadHolder(pairsHolder)
  local pileHolder = {}
  local currentLine = getCurrentLine()
  local i = 0
  for c in currentLine:gmatch"." do
    if str.quotes.set[c] then str.quotes.loadToken(pairsHolder, pileHolder, c, i) end
    i = i + 1
  end
end

local function selectMoving(touple)
  local lineNumber = line('.')
  cursor(lineNumber, touple[1] + 2)
  execute('normal<Esc>v')
  cursor(lineNumber, touple[2])
end

function beginPowerSelection(_pairsHolder)
  local currPos = col('.') - 1

  -- reuse pairsholder if given
  local pairsHolder
  if not _pairsHolder then
    pairsHolder = {}
    loadHolder(pairsHolder)
  else
    pairsHolder = _pairsHolder
  end

  -- try to select between
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
    selectMoving(closest)
    return
  end

  -- try to select forward
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
    selectMoving(closest)
    return
  end

  -- try to select backwards
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

  if closest then selectMoving(closest) end
end

local function findLeftIndex(currRight, pairsHolder)
  for key in pairs(pairsHolder) do
    for left, right in toupleArrayElement(pairsHolder[key]) do
     if currRight == right then return left end
    end
  end
  return false
end

function cyclePowerSelection()
  local currRight = col('.')

  local pairsHolder = {}
  loadHolder(pairsHolder)

  local currLeft = findLeftIndex(currRight, pairsHolder)
  if currLeft == false then return end

  -- find next occurrence
  local nextPair = { currLeft, currRight }
  local minLeft = 1/0 -- inf
  for key in pairs(pairsHolder) do
    for left, right in toupleArrayElement(pairsHolder[key]) do
      if nextPair[1] < left and left < minLeft then
        minLeft = left
        nextPair = { left, right }
      end
    end
  end

  if currLeft < nextPair[1] then
    selectMoving(nextPair)
    return
  end

  -- go to beggining and start again
  execute('normal<Esc>^')
  beginPowerSelection(pairsHolder)
end
