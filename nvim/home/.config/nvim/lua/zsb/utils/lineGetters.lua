function GetSameIndentLin(direction, lineMarker, originalIndent)
	local inc, endOfFile = GetDirectionalProps(direction)
	local existsSameIndent = false

	while not existsSameIndent and lineMarker ~= endOfFile do
		lineMarker = lineMarker + inc
		existsSameIndent = GetIndent(lineMarker) == originalIndent

		if existsSameIndent and IsEmptyLine(lineMarker) then
			existsSameIndent = false
		end
	end

	if existsSameIndent then
		return lineMarker
	else
		return GetCurrentLNum()
	end
end

function GetLesserIndent(direction, lineMarker)
	local inc, endOfFile = GetDirectionalProps(direction)

	local originalIndent = GetIndent(lineMarker)

	local gotLesserIndent = false

	while lineMarker ~= endOfFile do
		lineMarker = lineMarker + inc

		gotLesserIndent = GetIndent(lineMarker) < originalIndent

		if gotLesserIndent and not IsEmptyLine(lineMarker) then
			break
		end
	end

	return lineMarker
end

function GetSafeLesserIndent(direction)
	local lineMarker = GetFirstNoEmptyLine(direction, GetCurrentLNum())

	local originalInent = GetIndent(lineMarker)

	if originalInent == 0 then
		return GetSameIndentLin(direction, lineMarker, GetIndent(GetCurrentLNum()))
	end

	return GetLesserIndent(direction, lineMarker)
end
