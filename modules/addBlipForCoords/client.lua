---@param options VxBlipOptions
---@return integer
function vx.addBlipForCoords(options)
   local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
   vx.applyBlipOptions(blip, options)

   return blip
end

return vx.addBlipForCoords
