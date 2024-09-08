---@diagnostic disable: deprecated
---@deprecated
vx.blip = {}

---@param blip integer
---@param options VxBlipOptions
function vx.blip.applyOptions(blip, options)
   return vx.applyBlipOptions(blip, options)
end

---@param options VxBlipOptions
---@return integer
function vx.blip.addForCoord(options)
   return vx.addBlipForCoords(options)
end

---@param options EntityBlipOptions
---@return integer
function vx.blip.addForEntity(options)
   return vx.addBlipForEntity(options)
end

---@param options AreaBlipOptions
---@return integer
function vx.blip.addForArea(options)
   return vx.addBlipForArea(options)
end

---@param options RadiusBlipOptions
---@return integer
function vx.blip.addForRadius(options)
   local blip = AddBlipForRadius(options.coords.x, options.coords.y, options.coords.z, options.radius)
   vx.blip.applyOptions(blip, options)

   return blip
end

return vx.blip
