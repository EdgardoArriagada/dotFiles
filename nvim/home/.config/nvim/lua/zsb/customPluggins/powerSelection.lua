local ENCLOSING = 1
local QUOTES = 2

local MIN_NEOVIM_COL = 1

local getStartOfVisualSelection = function()
	return vim.fn.getpos("v")[3]
end

local function safePush(pile, element, i)
	if pile[element] then
		table.insert(pile[element], i)
	else
		pile[element] = { i }
	end
end

local function safePop(pile, element)
	if pile[element] then
		return table.remove(pile[element])
	end
	return nil
end

local enclosingLeftTokens = {
	["("] = true,
	["["] = true,
	["{"] = true,
	["<"] = true,
}

local rightToLeftDictionary = {
	[")"] = "(",
	["]"] = "[",
	["}"] = "{",
	[">"] = "<",
}

local enclosingStruct = {
	tokens = {
		["("] = true,
		[")"] = true,
		["["] = true,
		["]"] = true,
		["{"] = true,
		["}"] = true,
		["<"] = true,
		[">"] = true,
	},
	loadToken = function(pairsHolder, pilesStorage, token, i)
		if enclosingLeftTokens[token] then
			safePush(pilesStorage, token, i)
			return
		end

		local leftIndex = safePop(pilesStorage, rightToLeftDictionary[token])

		if leftIndex then
			table.insert(pairsHolder, { leftIndex, i })
		end
	end,
}

local quotesStruct = {
	tokens = {
		["'"] = true,
		['"'] = true,
		["`"] = true,
	},
	loadToken = function(pairsHolder, pilesStorage, token, i)
		local leftIndex = safePop(pilesStorage, token)

		if leftIndex then
			table.insert(pairsHolder, { leftIndex, i })
			return
		end

		safePush(pilesStorage, token, i)
	end,
}

local function hasPowerSelection(selectionType)
	local currentLine = getCurrentLine()
	local startVisualPos = getStartOfVisualSelection()

	local leftToken = currentLine:sub(startVisualPos - 1, startVisualPos - 1)
	local isQuoteSelection = selectionType == QUOTES

	-- if does not has left token
	if isQuoteSelection then
		if not quotesStruct.tokens[leftToken] then
			return false
		end
	else
		if not enclosingStruct.tokens[leftToken] then
			return false
		end
	end

	local endVisualPos = col(".")

	local rightToken = currentLine:sub(endVisualPos + 1, endVisualPos + 1)

	if isQuoteSelection then
		return leftToken == rightToken
	else -- encosing
		return rightToLeftDictionary[rightToken] == leftToken
	end
end

local function createPairsHolder(selectionType)
	local result = {} -- { {left1, rigth1}, {left2, rigth2}, ... }
	local pilesStorage = {} --  { [token] = { {left1, rigth1}, {left2, right2}, ... } }

	local currentStructure = selectionType == ENCLOSING and enclosingStruct or quotesStruct

	local tokens = currentStructure.tokens
	local loadToken = currentStructure.loadToken

	local i = 1
	for token in getCurrentLine():gmatch(".") do
		if tokens[token] then
			loadToken(result, pilesStorage, token, i)
		end
		i = i + 1
	end

	-- unload
	pilesStorage = nil
	currentStructure = nil
	tokens = nil
	loadToken = nil

	return result
end

local function selectMoving(touple)
	local lineNumber = line(".")
	cursor(lineNumber, touple[1] + 1)
	Execute("normal<Esc>v")
	cursor(lineNumber, touple[2] - 1)
end

function BeginPowerSelection(selectionType, recycledPairsHolder, givenCol)
	local currCol = givenCol or col(".")
	local pairsHolder = recycledPairsHolder or createPairsHolder(selectionType)

	local closestPair = nil

	local function unload()
		pairsHolder = nil
		recycledPairsHolder = nil
		closestPair = nil
	end

	-- try to select between
	local minLeft = -1
	for left, right in toupleArrayElement(pairsHolder) do
		if left <= currCol and currCol <= right then
			if minLeft < left then
				minLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		selectMoving(closestPair)
		unload()
		return
	end

	-- try to select forward
	closestPair = nil
	minLeft = 1 / 0 -- inf
	for left, right in toupleArrayElement(pairsHolder) do
		if currCol < left and currCol < right then
			if left < minLeft then
				minLeft = left
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		selectMoving(closestPair)
		unload()
		return
	end

	-- try to select backwards
	closestPair = nil
	local maxRight = -1
	for left, right in toupleArrayElement(pairsHolder) do
		if left < currCol and right < currCol then
			if maxRight < right then
				maxRight = right
				closestPair = { left, right }
			end
		end
	end

	if closestPair then
		selectMoving(closestPair)
	end

	unload()
end

local function findLeftIndex(currRight, pairsHolder)
	for left, right in toupleArrayElement(pairsHolder) do
		if currRight == right then
			return left
		end
	end
end

function CyclePowerSelection(selectionType)
	local currRightCol = col(".") + 1

	local pairsHolder = createPairsHolder(selectionType)

	local currLeftCol = findLeftIndex(currRightCol, pairsHolder) or getStartOfVisualSelection()

	-- find next occurrence
	local nextPair = nil
	local minLeft = 1 / 0 -- inf
	for left, right in toupleArrayElement(pairsHolder) do
		if minLeft > left and left > currLeftCol then
			minLeft = left
			nextPair = { left, right }
		end
	end

	if nextPair then
		selectMoving(nextPair)

		-- unload
		pairsHolder = nil
		nextPair = nil
		return
	end

	BeginPowerSelection(selectionType, pairsHolder, MIN_NEOVIM_COL)
end

-- enclosing
keymap.set("n", "W", function()
	BeginPowerSelection(ENCLOSING)
end)

keymap.set("v", "W", function()
	CyclePowerSelection(ENCLOSING)
end)

-- quotes
keymap.set({ "o", "v" }, "'", function()
	if hasPowerSelection(QUOTES) then
		CyclePowerSelection(QUOTES)
	else
		BeginPowerSelection(QUOTES)
	end
end)

-- Test string
-- () => ({foo} ({bar}))
-- ${zsb:='zsb'} # "$foo" ` 'ba' 'bi' " ` " '''
-- ${zsb:='zsb'} () {} < > [ ] ` ' " '
