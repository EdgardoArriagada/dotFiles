keymap.set({ 'o', 'v' }, "'", function()
  execute('normal <Esc>')
  perfectlySelectString({"'", '"'})
end, { noremap = true, silent = true })

keymap.set({ 'o', 'v' }, '"', function()
  execute('normal <Esc>')
  perfectlySelectString({'"', "'"})
end, { noremap = true, silent = true })

local function didSelectBetween(middle)
  local left = col('v')
  local right = col('.')
  return left ~= right and left -1 <= middle and middle <= right +1
end

local function restorePos(position)
  setpos('.', position)
end

local function pressEscape()
  execute('normal <Esc>')
end

local function didSelect()
  return col('.') ~= col('v')
end

function perfectlySelectString(quotes)
  local savedPos = getpos('.')
  local savedColumn = savedPos[3]

  local function restoreValues()
    restorePos(savedPos)
    pressEscape()
  end

  local function didMove()
    return col('.') ~= savedColumn
  end

  -- If did select between cursor
  for quote in arrayElement(quotes) do
    execute('normal vi'..quote)

    if didSelectBetween(savedColumn) then
      return
    end

    restoreValues()
  end

  for quote in arrayElement(quotes) do
    -- If did select goind forward
    execute('normal vi'..quote)

    if didSelect() or didMove() then
      return
    end

    restoreValues()
  end

  for quote in arrayElement(quotes) do
    -- If did select goind backwards
    execute('normal F'..quote..'vi'..quote)

    if didSelect() or didMove() then
      return
    end

    restoreValues()
  end
end
