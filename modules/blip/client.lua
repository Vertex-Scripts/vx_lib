vx.blip = {}

---@class BlipOptions
---@field coords? vector3
---@field sprite? number
---@field color? number
---@field text? string
---@field scale? number
---@field shortRange? boolean

---@class EntityBlipOptions : BlipOptions
---@field entity number

---@class AreaBlipOptions : BlipOptions
---@field area vector2

---@class AreaBlipOptions : BlipOptions
---@field radius number

---@param blip integer
---@param options BlipOptions
function vx.blip.applyOptions(blip, options)
   if options.sprite then SetBlipSprite(blip, options.sprite) end
   if options.color then SetBlipColour(blip, options.color) end
   if options.text then
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(options.text)
      EndTextCommandSetBlipName(blip)
   end

   if options.scale then SetBlipScale(blip, options.scale) end
   if options.shortRange then SetBlipAsShortRange(blip, true) end
end

---@param options BlipOptions
---@return integer
function vx.blip.addForCoord(options)
   local blip = AddBlipForCoord(options.coords.x, options.coords.y, options.coords.z)
   vx.blip.applyOptions(blip, options)

   return blip
end

---@param options EntityBlipOptions
---@return integer
function vx.blip.addForEntity(options)
   local blip = AddBlipForEntity(options.entity)
   vx.blip.applyOptions(blip, options)

   return blip
end

---@param options AreaBlipOptions
---@return integer
function vx.blip.addBlipForArea(options)
   local blip = AddBlipForArea(options.coords.x, options.coords.y, options.coords.z, options.area.x, options.area.y)
   vx.blip.applyOptions(blip, options)

   return blip
end

---@param options AreaBlipOptions
---@return integer
function vx.blip.addBlipForRadius(options)
   local blip = AddBlipForRadius(options.coords.x, options.coords.y, options.coords.z, options.radius)
   vx.blip.applyOptions(blip, options)

   return blip
end

return vx.blip
