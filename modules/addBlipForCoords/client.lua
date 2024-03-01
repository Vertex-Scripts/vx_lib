---@class BlipOptions
---@field coords vector3
---@field sprite? number
---@field color? number
---@field text? string
---@field scale? number
---@field shortRange? boolean

---@param options BlipOptions
function cfx.addBlipForCoords(options)
   local coords = options.coords
   local blip = AddBlipForCoord(coords.x, coords.y, coords.z)

   if options.sprite then SetBlipSprite(blip, options.sprite) end
   if options.color then SetBlipColour(blip, options.color) end
   if options.text then
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(options.text)
      EndTextCommandSetBlipName(blip)
   end

   if options.scale then SetBlipScale(blip, options.scale) end
   if options.shortRange then SetBlipAsShortRange(blip, true) end

   return blip
end

return cfx.addBlipForCoords
