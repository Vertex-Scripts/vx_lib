---@param value any
---@param expectedTypes type|type[]
function vx.typeCheck(name, value, expectedTypes)
   if type(expectedTypes) == "table" then
      for _, expectedType in ipairs(expectedTypes) do
         if type(value) == expectedType then return end
      end

      error(("expected %s to have type '%s' (received %s)"):format(name, table.concat(expectedTypes, ", "), type(value)),
         2)
   else
      if type(value) ~= expectedTypes then
         error(("expected %s to have type '%s' (received %s)"):format(name, expectedTypes, type(value)), 2)
      end
   end
end

return vx.typeCheck
