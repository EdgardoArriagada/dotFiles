function GetDirectionalProps(direction)
	if direction == "j" then
		return 1, line("$")
	elseif direction == "k" then
		return -1, 1
	end
end

function IsEmptyString(input)
	return input:match("^%s*$") ~= nil
end

function IsEmptyLine(line)
	return IsEmptyString(vim.fn.getline(line))
end

function GetFirstNoEmptyLine(direction, lineMarker)
	local inc, endOfFile = GetDirectionalProps(direction)
	while lineMarker ~= endOfFile do
		if not IsEmptyLine(lineMarker) then
			return lineMarker
		end

		lineMarker = lineMarker + inc
	end
	return lineMarker
end

function LookForIndentation(direction)
	-- Go to beggin of line and add to jump list
	Execute("normal" .. line(".") .. "G^")

	local lineMarker = GetFirstNoEmptyLine(direction, line("."))

	Execute("normal" .. getSameIndentLine(direction, lineMarker) .. "G^")
end

function ArrayElement(t)
	local i = 0

	return function()
		i = i + 1
		return t[i]
	end
end

function ArrayElementBackward(t)
	local i = #t + 1

	return function()
		i = i - 1
		return t[i]
	end
end

function ToupleArrayElement(t)
	local i = 0

	return function()
		i = i + 1
		if t[i] then
			return t[i][1], t[i][2]
		end
	end
end

function FromShell(command)
	local handle = io.popen(command)

	if handle then
		local result = handle:read("*a")
		handle:close()
		return result
	end

	return nil
end

function EscapePattern(text)
	return text:gsub("([^%w])", "%%%1")
end

function EscapeForRegex(x)
	return (
		x
			:gsub("%\\", "\\\\")
			:gsub("%^", "\\^")
			:gsub("%$", "\\$")
			:gsub("%~", "\\~")
			:gsub("%.", "\\.")
			:gsub("%[", "\\[")
			:gsub("%]", "\\]")
			:gsub("%*", "\\*")
			:gsub("%+", "\\+")
			:gsub("%-", "\\-")
			:gsub("%/", "\\/")
			:gsub("%&", "\\&")
	)
end

function GetVisualSelectionInLine()
	local currentLine = getCurrentLine()
	local startVisualPos = vim.fn.getpos("v")[3]
	local currPos = col(".")
	return string.sub(currentLine, startVisualPos, currPos)
end

function MakeMultimap(mode, action, opts)
	return function(keys)
		for _, key in ipairs(keys) do
			kset(mode, key, action, opts)
		end
	end
end

function IsCurrentLineFolded()
	return vim.fn.foldclosed(".") ~= -1
end

-- usefull alias to print anythin even tables
function P(input)
	print(vim.inspect(input))
end
