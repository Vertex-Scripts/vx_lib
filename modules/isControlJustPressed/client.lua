---@param key VxKeyName | number
---@param padIndex? number
---@return boolean
function vx.isControlJustPressed(key, padIndex)
   return vx.isControlInteractedWith(IsControlJustPressed, key, padIndex)
end

return vx.isControlJustPressed
