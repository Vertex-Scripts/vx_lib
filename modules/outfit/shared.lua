vx.outfit = {}

---@class Variations
---@field drawable number
---@field texture? number
---@field palette? number

---@class Outfit
---@field face? Variations
---@field mask? Variations
---@field hair? Variations
---@field torso? Variations
---@field leg? Variations
---@field bag? Variations
---@field shoes? Variations
---@field accessories? Variations
---@field undershirt? Variations
---@field kevlar? Variations
---@field badge? Variations
---@field torso2? Variations

local componentIndexes = {
   face = 0,
   mask = 1,
   hair = 2,
   torso = 3,
   leg = 4,
   bag = 5,
   shoes = 6,
   accessories = 7,
   undershirt = 8,
   kevlar = 9,
   badge = 10,
   torso2 = 11
}

---@param components table<number, Variations>
---@param ped number
---`Shared`
function vx.outfit.apply(components, ped)
   for index, component in pairs(components) do
      if component.drawable then
         SetPedComponentVariation(ped, index, component.drawable, component.texture or 0, component.palette or 0)
      end
   end
end

---@param outfit Outfit
---@return table<number, Variations>
---`Shared`
function vx.outfit.create(outfit)
   local components = {}
   for component in pairs(outfit) do
      local index = componentIndexes[component]
      if index then
         components[index] = outfit[component]
      end
   end

   return components
end

---@param ped number
---@return table<number, Variations>
---`Client`
function vx.outfit.getComponentsFromPed(ped)
   if vx.context == "server" then
      error("vx.outfit.getComponentsFromPed() is only available on the client")
   end

   ped = vx.cache.ped

   local components = {}
   for _, index in pairs(componentIndexes) do
      local variations = {
         drawable = GetPedDrawableVariation(ped, index),
         texture = GetPedTextureVariation(ped, index),
         palette = GetPedPaletteVariation(ped, index)
      }

      components[index] = variations
   end

   return components
end

return vx.outfit
