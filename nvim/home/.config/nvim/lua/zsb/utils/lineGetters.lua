function getSameIndentLine(direction, lineMarker)
  local inc, endOfFile = GetDirectionalProps(direction)
  local existsSameIndent = false
  local originalIndent = indent('.')

  while not existsSameIndent and lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc
    existsSameIndent = indent(lineMarker) == originalIndent

    if existsSameIndent and IsEmptyLine(lineMarker) then
      existsSameIndent = false
    end
  end

  if existsSameIndent then
    return lineMarker
  else
    return line('.')
  end
end

function getLesserIndent(direction, lineMarker)
  local inc, endOfFile = GetDirectionalProps(direction)

  local originalIndent = indent(lineMarker)

  local gotLesserIndent = false

  while lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc

    gotLesserIndent = indent(lineMarker) < originalIndent

    if gotLesserIndent and not IsEmptyLine(lineMarker) then break end
  end

  return lineMarker
end

function getStopLine(direction)
  local inc, endOfFile = GetDirectionalProps(direction)

  local lineMarker = line('.')
  local isStartEmpty = IsEmptyLine(lineMarker)
  local originalIndent = indent('.')

  local function didSwitch(line)
     if isStartEmpty then
       return not IsEmptyLine(line)
     else
       return IsEmptyLine(line)
     end
  end

  while not didSwitch(lineMarker) and lineMarker ~= endOfFile do
     lineMarker = lineMarker + inc

     if not IsEmptyLine(lineMarker) and indent(lineMarker) < originalIndent then
       lineMarker = lineMarker - inc
       break
    end
  end

  return lineMarker
end
