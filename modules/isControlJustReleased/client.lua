---@param key VxKeyName | number
---@param padIndex? number
---@return boolean
function vx.isControlJustReleased(key, padIndex)
   return vx.isControlInteractedWith(IsControlJustReleased, key, padIndex)
end

return vx.isControlJustReleased
