-- For now, this script is only usefull for logging crashes.
-- the 'return thing' statement will be usefull
-- when we find a way to exit original script using the callback
--
function withFallback(a, b, cb)
  local ok, thing = pcall(a, b)

  if not ok then cb() end

  return thing
end


function whenOk(a, b, cb)
  local ok, thing = pcall(a, b)

  if not ok then return end

  cb(thing)
end

