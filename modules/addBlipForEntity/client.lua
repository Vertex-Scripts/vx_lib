---@class EntityBlipOptions : VxBlipOptions
---@field entity number

---@param options EntityBlipOptions
---@return integer
function vx.addBlipForEntity(options)
   local blip = AddBlipForEntity(options.entity)
   vx.applyBlipOptions(blip, options)

   return blip
end

return vx.addBlipForEntity
