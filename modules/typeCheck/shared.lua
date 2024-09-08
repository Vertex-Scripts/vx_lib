---@param value any
---@param expectedType type
function vx.typeCheck(name, value, expectedType)
   if type(value) ~= expectedType then
      error(("expected %s to have type '%s' (received %s)"):format(name, expectedType, type(value)), 2)
   end
end

return vx.typeCheck
