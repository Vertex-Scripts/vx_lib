---@param action string
---@param data any
function vx.sendNuiAction(action, data)
   SendNUIMessage({
      action = action,
      data = data
   })
end

return vx.sendNuiAction
