local ENCLOSING = 1
local QUOTES = 2

local getStartOfVisualSelection = function()
	return vim.fn.getpos("v")[3]
end

local function safePush(pile, element, i)
	if pile[element] then
		table.insert(pile[element], i)
		return
	end
	pile[element] = { i }
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
			table.insert(pairsHolder, { leftIndex, i }) -- where token = leftToken
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

local structures = {}
structures[ENCLOSING] = enclosingStruct
structures[QUOTES] = quotesStruct

local function hasPowerSelection(selectionType)
	local currentLine = getCurrentLine()
	local startVisualPos = getStartOfVisualSelection()

	local leftToken = currentLine:sub(startVisualPos - 1, startVisualPos - 1)

	-- if does not has left token
	if not structures[selectionType].tokens[leftToken] then
		return false
	end

	local endVisualPos = col(".")

	local rightToken = currentLine:sub(endVisualPos + 1, endVisualPos + 1)

	if selectionType == QUOTES then
		return leftToken == rightToken
	end

	if selectionType == ENCLOSING then
		return rightToLeftDictionary[rightToken] == leftToken
	end
end

local function loadHolder(selectionType, pairsHolder)
	local pilesStorage = {} --  { [token] = { {left1, rigth1}, {left2, right2}, ... } }
	local currentStructure = structures[selectionType]
	local tokens = currentStructure.tokens
	local loadToken = currentStructure.loadToken

	local i = 1
	for token in getCurrentLine():gmatch(".") do
		if tokens[token] then
			loadToken(pairsHolder, pilesStorage, token, i)
		end
		i = i + 1
	end

	-- unload
	pilesStorage = nil
	currentStructure = nil
	tokens = nil
	loadToken = nil
end

local function selectMoving(touple)
	local lineNumber = line(".")
	cursor(lineNumber, touple[1] + 1)
	Execute("normal<Esc>v")
	cursor(lineNumber, touple[2] - 1)
end

function BeginPowerSelection(selectionType, _pairsHolder)
	local currPos = col(".")

	-- reuse pairsholder if given
	local pairsHolder -- { {left1, rigth1}, {left2, rigth2}, ... }
	if _pairsHolder then
		pairsHolder = _pairsHolder
	else
		pairsHolder = {}
		loadHolder(selectionType, pairsHolder)
	end

	-- try to select between
	local closestPair = nil

	local function unload()
		pairsHolder = nil
		_pairsHolder = nil
		closestPair = nil
	end

	local minLeft = -1
	for left, right in toupleArrayElement(pairsHolder) do
		if left <= currPos and currPos <= right then
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
		if currPos < left and currPos < right then
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
		if left < currPos and right < currPos then
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
	local currRight = col(".") + 1

	local pairsHolder = {} -- { {left1, rigth1}, {left2, rigth2}, ... }
	loadHolder(selectionType, pairsHolder)

	local currLeft = findLeftIndex(currRight, pairsHolder) or getStartOfVisualSelection()

	-- find next occurrence
	local nextPair = nil
	local minLeft = 1 / 0 -- inf
	for left, right in toupleArrayElement(pairsHolder) do
		if minLeft > left and left > currLeft then
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

	-- go to beggining and start again
	Execute("normal<Esc>^")
	BeginPowerSelection(selectionType, pairsHolder)
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
		Execute("normal<Esc>")
		BeginPowerSelection(QUOTES)
	end
end)

-- Test string
-- () => ({foo} ({bar}))
-- ${zsb:='zsb'} # "$foo" ` 'ba' 'bi' " ` " '''
-- ${zsb:='zsb'} () {} < > [ ] ` ' " '
