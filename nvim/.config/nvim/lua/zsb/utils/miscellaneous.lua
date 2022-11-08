function getDirectionalProps(direction)
	if direction == "j" then
		return 1, line("$")
	elseif direction == "k" then
		return -1, 1
	end
end

function isEmptyString(input)
	for c in input:gmatch(".") do
		if c ~= " " then
			return false
		end
	end

	return true
end

function isEmptyLine(line)
	return isEmptyString(vim.fn.getline(line))
end

function getFirstNoEmptyLine(direction, lineMarker)
	local inc, endOfFile = getDirectionalProps(direction)
	while lineMarker ~= endOfFile do
		if not isEmptyLine(lineMarker) then
			return lineMarker
		end

		lineMarker = lineMarker + inc
	end
	return lineMarker
end

function lookForIndentation(direction)
	-- Go to beggin of line and add to jump list
	execute("normal" .. line(".") .. "G^")

	local lineMarker = getFirstNoEmptyLine(direction, line("."))

	execute("normal" .. getSameIndentLine(direction, lineMarker) .. "G^")
end

function arrayElement(t)
	local i = 0

	return function()
		i = i + 1
		return t[i]
	end
end

function arrayElementBackward(t)
	local i = #t + 1

	return function()
		i = i - 1
		return t[i]
	end
end

function toupleArrayElement(t)
	local i = 0

	return function()
		i = i + 1
		if t[i] then
			return t[i][1], t[i][2]
		end
	end
end

function fromShell(command)
	local handle = io.popen(command)

	if handle then
		local result = handle:read("*a")
		handle:close()
		return result
	end

	return nil
end

function escape_pattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function escapeForRegex(x)
	return (
		x:gsub("%^", "\\^")
			:gsub("%$", "\\$")
			:gsub("%~", "\\~")
			:gsub("%.", "\\.")
			:gsub("%[", "\\[")
			:gsub("%]", "\\]")
			:gsub("%*", "\\*")
			:gsub("%+", "\\+")
			:gsub("%-", "\\-")
			:gsub("%?", "\\?")
			:gsub("%/", "\\/")
	)
end

function getVisualSelectionInLine()
	local currentLine = getCurrentLine()
	local startVisualPos = vim.fn.getpos("v")[3]
	local currPos = col(".")
	return string.sub(currentLine, startVisualPos, currPos)
end
