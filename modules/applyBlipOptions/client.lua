---@class VxBlipOptions
---@field coords? vector3
---@field sprite? number
---@field color? number
---@field text? string
---@field scale? number
---@field isFlashing? boolean
---@field shortRange? boolean

---@param blip integer
---@param options VxBlipOptions
function vx.applyBlipOptions(blip, options)
   if options.sprite then SetBlipSprite(blip, options.sprite) end
   if options.color then SetBlipColour(blip, options.color) end
   if options.text then
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(options.text)
      EndTextCommandSetBlipName(blip)
   end

   if options.scale then SetBlipScale(blip, options.scale) end
   if options.shortRange then SetBlipAsShortRange(blip, true) end
   if options.isFlashing then SetBlipFlashes(blip, true) end
end

return vx.applyBlipOptions
