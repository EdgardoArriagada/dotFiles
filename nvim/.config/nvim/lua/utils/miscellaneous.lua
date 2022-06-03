function strip(input)
   return (input:gsub("^%s*(.-)%s*$", "%1"))
end

function isEmptyString(input)
  if #input == 0 then return true end

  return #strip(input) == 0
end

function isEmptyLine(line)
  return isEmptyString(vim.fn.getline(line))
end
