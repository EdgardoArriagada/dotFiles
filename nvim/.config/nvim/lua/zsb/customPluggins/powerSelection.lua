-- enclosing
keymap.set("n", "W", function()
	beginPowerSelection("enclosing")
end)

keymap.set("v", "W", function()
	cyclePowerSelection("enclosing")
end)

-- quotes
keymap.set({ "o", "v" }, "'", function()
	execute("normal<Esc>")
	beginPowerSelection("quotes")
end)

keymap.set({ "o", "v" }, "L", function()
	cyclePowerSelection("quotes")
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

local enclosingLeftSet = {
	["("] = true,
	["["] = true,
	["{"] = true,
	["<"] = true,
}

local rightToLeft = {
	[")"] = "(",
	["]"] = "[",
	["}"] = "{",
	[">"] = "<",
}

local structures = {
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
		loadToken = function(pairsHolder, pilesStorage, token, i)
			if enclosingLeftSet[token] then
				safePush(pilesStorage, token, i)
				return
			end

			local leftToken = rightToLeft[token]
			local leftIndex = safePop(pilesStorage, leftToken)

			if leftIndex ~= nil then
				table.insert(pairsHolder, { leftIndex, i }) -- where token = leftToken
			end
		end,
	},
	quotes = {
		set = {
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

local function loadHolder(ctx, pairsHolder)
	local pilesStorage = {} --  { [token] = { {left1, rigth1}, {left2, right2}, ... } }
	local currentLine = getCurrentLine()
	local i = 1
	for c in currentLine:gmatch(".") do
		if structures[ctx].set[c] then
			structures[ctx].loadToken(pairsHolder, pilesStorage, c, i)
		end
		i = i + 1
	end
end

local function selectMoving(touple)
	local lineNumber = line(".")
	cursor(lineNumber, touple[1] + 1)
	execute("normal<Esc>v")
	cursor(lineNumber, touple[2] - 1)
end

function beginPowerSelection(ctx, _pairsHolder)
	local currPos = col(".")

	-- reuse pairsholder if given
	local pairsHolder -- { {left1, rigth1}, {left2, rigth2}, ... }
	if _pairsHolder then
		pairsHolder = _pairsHolder
	else
		pairsHolder = {}
		loadHolder(ctx, pairsHolder)
	end

	-- try to select between
	local closest = false
	for left, right in toupleArrayElement(pairsHolder) do
		if left <= currPos and currPos <= right then
			if not closest then
				closest = { left, right }
			else
				if closest[1] < left then
					closest = { left, right }
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
	for left, right in toupleArrayElement(pairsHolder) do
		if currPos < left and currPos < right then
			if not closest then
				closest = { left, right }
			else
				if left < closest[1] then
					closest = { left, right }
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
	for left, right in toupleArrayElement(pairsHolder) do
		if left < currPos and right < currPos then
			if not closest then
				closest = { left, right }
			else
				if closest[2] < right then
					closest = { left, right }
				end
			end
		end
	end

	if closest then
		selectMoving(closest)
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

function cyclePowerSelection(ctx)
	local currRight = col(".") + 1

	local pairsHolder = {} -- { {left1, rigth1}, {left2, rigth2}, ... }
	loadHolder(ctx, pairsHolder)

	local currLeft = findLeftIndex(currRight, pairsHolder)
	if currLeft == false then
		return
	end

	-- find next occurrence
	local nextPair = {}
	local minLeft = 1 / 0 -- inf
	for left, right in toupleArrayElement(pairsHolder) do
		if minLeft > left and left > currLeft then
			minLeft = left
			nextPair = { left, right }
		end
	end

	if #nextPair ~= 0 then
		selectMoving(nextPair)
		return
	end

	-- go to beggining and start again
	execute("normal<Esc>^")
	beginPowerSelection(ctx, pairsHolder)
end

-- Test string
-- () => ({foo} ({bar}))
-- ${zsb:='zsb'} # "$foo" ` 'ba' `
