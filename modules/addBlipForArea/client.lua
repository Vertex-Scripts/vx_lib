---@class AreaBlipOptions : VxBlipOptions
---@field area vector2

---@param options AreaBlipOptions
---@return integer
function vx.addBlipForArea(options)
   local blip = AddBlipForArea(options.coords.x, options.coords.y, options.coords.z, options.area.x, options.area.y)
   vx.applyBlipOptions(blip, options)

   return blip
end

return vx.addBlipForArea
