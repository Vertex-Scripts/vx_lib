vx.nui = {}

---@param action string
---@param data any
function vx.nui.sendAction(action, data)
   SendNUIMessage({
      action = action,
      data = data
   })
end

return vx.nui
