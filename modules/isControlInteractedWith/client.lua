---@param func fun(padIndex: number, keyCode: number): boolean
---@param key VxKeyName | number
---@param padIndex? number
---@return boolean
---Used internally
function vx.isControlInteractedWith(func, key, padIndex)
   padIndex = padIndex or 0
   vx.typeCheck("key", key, { "string", "number" })

   local keyCode = key
   if type(keyCode) == "string" then
      keyCode = vx.keybinds[keyCode]
   end

   ---@cast keyCode number
   if not keyCode then
      error(("Invalid key '%s'"):format(key), 2)
   end

   return func(padIndex, keyCode)
end

return vx.isControlInteractedWith
