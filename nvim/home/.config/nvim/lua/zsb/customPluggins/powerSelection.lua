-- enclosing
keymap.set("n", "W", function()
	BeginPowerSelection("enclosing")
end)

keymap.set("v", "W", function()
	CyclePowerSelection("enclosing")
end)

-- quotes
keymap.set({ "o", "v" }, "'", function()
	Execute("normal<Esc>")
	BeginPowerSelection("quotes")
end)

keymap.set({ "o", "v" }, "L", function()
	CyclePowerSelection("quotes")
end)

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

local structures = {
	enclosing = {
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

			if leftIndex ~= nil then
				table.insert(pairsHolder, { leftIndex, i }) -- where token = leftToken
			end
		end,
	},
	quotes = {
		tokens = {
			["'"] = true,
			['"'] = true,
			["`"] = true,
		},
		loadToken = function(pairsHolder, pilesStorage, token, i)
			local leftIndex = safePop(pilesStorage, token)

			if leftIndex ~= nil then
				table.insert(pairsHolder, { leftIndex, i })
				return
			end

			safePush(pilesStorage, token, i)
		end,
	},
}

local function loadHolder(selectionType, pairsHolder)
	local pilesStorage = {} --  { [token] = { {left1, rigth1}, {left2, right2}, ... } }
	local currentStructure = structures[selectionType]

	local i = 1
	for token in getCurrentLine():gmatch(".") do
		if currentStructure.tokens[token] then
			currentStructure.loadToken(pairsHolder, pilesStorage, token, i)
		end
		i = i + 1
	end

	-- unload
	pilesStorage = nil
	currentStructure = nil
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
	local closestPair = false

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
	closestPair = false
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
	closestPair = false
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
		unload()
	end
end

local function findLeftIndex(currRight, pairsHolder)
	for left, right in toupleArrayElement(pairsHolder) do
		if currRight == right then
			return left
		end
	end
	return false
end

function CyclePowerSelection(selectionType)
	local currRight = col(".") + 1

	local pairsHolder = {} -- { {left1, rigth1}, {left2, rigth2}, ... }
	loadHolder(selectionType, pairsHolder)

	local currLeft = findLeftIndex(currRight, pairsHolder)
	if currLeft == false then
		return
	end

	-- find next occurrence
	local nextPair = false
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

-- Test string
-- () => ({foo} ({bar}))
-- ${zsb:='zsb'} # "$foo" ` 'ba' " ` "
-- ${zsb:='zsb'} () {} < > [ ] ` ' " '
