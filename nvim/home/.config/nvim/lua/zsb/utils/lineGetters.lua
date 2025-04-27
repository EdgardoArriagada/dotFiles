function GetSameIndentLin(direction, lineMarker)
	local inc, endOfFile = GetDirectionalProps(direction)
	local existsSameIndent = false
	local originalIndent = GetIndent(GetCurrentLNum())

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
