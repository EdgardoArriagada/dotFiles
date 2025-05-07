function GetNextLineWithIndent(direction, currentLnum, indent)
	local inc, endOfFile = GetDirectionalProps(direction)
	local existsSameIndent = false

	while not existsSameIndent and currentLnum ~= endOfFile do
		currentLnum = currentLnum + inc
		existsSameIndent = GetIndent(currentLnum) == indent

		if existsSameIndent and IsEmptyLine(currentLnum) then
			existsSameIndent = false
		end
	end

	if existsSameIndent then
		return currentLnum
	else
		return GetCurrentLNum()
	end
end

function GetLesserIndent(direction, currentLnum)
	local inc, endOfFile = GetDirectionalProps(direction)

	local originalIndent = GetIndent(currentLnum)

	local gotLesserIndent = false

	while currentLnum ~= endOfFile do
		currentLnum = currentLnum + inc

		gotLesserIndent = GetIndent(currentLnum) < originalIndent

		if gotLesserIndent and not IsEmptyLine(currentLnum) then
			break
		end
	end

	return currentLnum
end

function GetSafeLesserIndent(direction)
	local currentLnum = GetFirstNoEmptyLine(direction, GetCurrentLNum())

	local originalInent = GetIndent(currentLnum)

	if originalInent == 0 then
		return GetNextLineWithIndent(direction, currentLnum, GetIndent(GetCurrentLNum()))
	end

	return GetLesserIndent(direction, currentLnum)
end
