---@param name string
---@param value any
---@param expectedTypes type|type[]
---@param message? string
function vx.typeCheck(name, value, expectedTypes, message)
   if type(expectedTypes) == "table" then
      for _, expectedType in ipairs(expectedTypes) do
         if type(value) == expectedType then return end
      end

      message = message or
          ("expected %s to have type '%s' (received %s)"):format(name, table.concat(expectedTypes, ", "), type(value))

      error(message, 2)
   else
      if type(value) ~= expectedTypes then
         message = message or
             ("expected %s to have type '%s' (received %s)"):format(name, expectedTypes, type(value))
         error(message, 2)
      end
   end
end

return vx.typeCheck
