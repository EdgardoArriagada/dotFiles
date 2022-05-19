-- For now, this script is only usefull for logging crashes.
-- the 'return thing' statement will be usefull
-- when we find a way to exit original script using the callback
function safeCall(a, b, cb)
  local ok, thing = pcall(a, b)

  if not ok then cb() end

  return thing
end

