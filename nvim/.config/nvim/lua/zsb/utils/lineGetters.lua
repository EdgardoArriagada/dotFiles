function getSameIndentLine(direction, lineMarker)
  local inc, endOfFile = getDirectionalProps(direction)
  local existsSameIndent = false
  local originalIndent = indent('.')

  while not existsSameIndent and lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc
    existsSameIndent = indent(lineMarker) == originalIndent

    if existsSameIndent and isEmptyLine(lineMarker) then
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
  local inc, endOfFile = getDirectionalProps(direction)

  local originalIndent = indent(lineMarker)

  local gotLesserIndent = false

  while lineMarker ~= endOfFile do
    lineMarker = lineMarker + inc

    gotLesserIndent = indent(lineMarker) < originalIndent

    if gotLesserIndent and not isEmptyLine(lineMarker) then break end
  end

  return lineMarker
end

function getStopLine(direction)
  local inc, endOfFile = getDirectionalProps(direction)

  local lineMarker = line('.')
  local isStartEmpty = isEmptyLine(lineMarker)
  local originalIndent = indent('.')

  local function didSwitch(line)
     if isStartEmpty then
       return not isEmptyLine(line)
     else
       return isEmptyLine(line)
     end
  end

  while not didSwitch(lineMarker) and lineMarker ~= endOfFile do
     lineMarker = lineMarker + inc

     if not isEmptyLine(lineMarker) and indent(lineMarker) < originalIndent then
       lineMarker = lineMarker - inc
       break
    end
  end

  return lineMarker
end
