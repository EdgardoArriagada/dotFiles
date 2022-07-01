keymap.set({ 'o', 'v' }, "'", function()
  execute('normal<Esc>')
  perfectlySelectString()
end)

keymap.set({ 'o', 'v' }, '"', function()
  execute('normal<Esc>')
  perfectlySelectString()
end)

keymap.set({ 'o', 'v' }, '`', function()
  execute('normal<Esc>')
  perfectlySelectString()
end)

keymap.set({ 'o', 'v' }, 'L', function()
  execute('normal<Esc><Right><Right>')
  perfectlySelectString()
end)

local set = {
  ["'"] = true,
  ['"'] = true,
  ['`'] = true,
}

local function loadToken(holder, pileHolder, token, i)
  local leftIndex = safePop(pileHolder, token)

  if leftIndex ~= nil then
    safePush(holder, token, { leftIndex, i })
    return
  end

  safePush(pileHolder, token, i)
end

local function loadHolder(holder)
  local pileHolder = {}
  local currentLine = getCurrentLine()
  local i = 0
  for c in currentLine:gmatch"." do
    if set[c] then loadToken(holder, pileHolder, c, i) end
    i = i + 1
  end
end

local function selectMoving(leftIndex, rightIndex)
  local lineNumber = line('.')
  cursor(lineNumber, leftIndex + 2)
  execute('normal<Esc>v')
  cursor(lineNumber, rightIndex)
end

function perfectlySelectString()
  local currPos = col('.') - 1
  local holder = {}
  loadHolder(holder)

  local closest = false
  for key in pairs(holder) do
    for left, right in toupleArrayElement(holder[key]) do
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
  for key in pairs(holder) do
    for left, right in toupleArrayElement(holder[key]) do
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
  for key in pairs(holder) do
    for left, right in toupleArrayElement(holder[key]) do
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
