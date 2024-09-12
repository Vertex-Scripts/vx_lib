---@class RadiusBlipOptions : VxBlipOptions
---@field radius number

---@param options RadiusBlipOptions
---@return integer
function vx.addBlipForRadius(options)
   local blip = AddBlipForRadius(options.coords.x, options.coords.y, options.coords.z, options.radius)
   vx.applyBlipOptions(blip, options)

   return blip
end

return vx.addBlipForRadius
